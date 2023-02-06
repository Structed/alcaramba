extends TileMap

# Receives a TileCard, Vector2 position
signal tile_removed

var _reference_tiles: TileCardCollection = TileCardCollection.new() # complete stack for tile info
var _starting_tile_id = 54
var _current_tile: TileCard = TileCard.new(_starting_tile_id, 0, TileCard.TileType.START, TileCard.WALL_SIDE_NONE)
var _max_size = [10, 10]
var _placement_mode : int = 0 setget _placement_mode_set # 0 = no placement, 1 = place tile, 2 = remove tile
var _max_int = 10000 # very big number needed for distance/connectivity calculations
var _number_of_tiles = 0

onready var _tilemap_overlay = get_node("%TileMap_valid_overlay")
onready var _distances = get_node("%TileMap_distances") # grid to check connectivity of valid tiles
onready var _inverse_distances = get_node("%TileMap_distances") # grid to check connectivity of invalid tiles
onready var _spare_tiles = get_node("%SpareTiles")

var tile_card_scene = preload("res://Drawable/Card/TileCardDrawable.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	_reference_tiles.initialize_for_game_start() # Implement Player stack and handover/keeping of tiles
	_reference_tiles.add_card(_current_tile)
	self._placement_mode = 0
	place_starting_tile()
	_update_distancemap(_distances)
	$TileMap_valid_overlay.hide()
	draw_placed_tiles()

	OverlayDebugInfo.show()
	OverlayDebugInfo.set_horizontal_align_right()
	OverlayDebugInfo.set_vertical_align_top()


# Called every frame
func _process(_delta):
	
	if _number_of_tiles != Global.active_player.town_tiles.size():
		update_town()

	if _placement_mode != 0:
		# TODO: confine mouse to town?
		pass

	if _placement_mode == 1:
		_tilemap_overlay.show()
	else:
		_tilemap_overlay.hide()


func _placement_mode_set(mode):
	_placement_mode = mode

	OverlayDebugInfo.set_label("PlacementMode",  "Placement Mode: "+ _placement_mode as String)


func _unhandled_input(event: InputEvent):
	# if _placement_mode is set for placing or removing
	if _placement_mode != 0:
		# if mouse is pressed
		if event is InputEventMouseButton && event.is_pressed():
			# get grid position
			var grid_position = world_to_map(get_local_mouse_position())
			var x = grid_position.x
			var y = grid_position.y

			OverlayDebugInfo.add_timed_label("Town x | y: %d | %d" % [x, y], 3)

			#left click and placing mode
			if event.button_index == 1 && _placement_mode == 1:
				if is_placement_valid(x, y, _current_tile._id):
					# place tile and leave placement mode
					place_tile(x, y, _current_tile)
					self._placement_mode = 0
					draw_placed_tiles()

			# left click and removing mode
			if event.button_index == 1 && _placement_mode == 2:
				# if cell not empty and cell is not starting tile and removed does not break connection
				var cell_to_remove = get_cell(x, y)
				if cell_to_remove != TileMap.INVALID_CELL && cell_to_remove != _starting_tile_id && _is_tile_removable(x, y):
					var _removed_tile_id = remove_tile(x, y) # remove tile and return its id
					# emit signal to send card to spare tiles
					emit_signal("tile_removed", _reference_tiles.get_card_info_by_id(_removed_tile_id))
				draw_placed_tiles()

# sync tilemap with players town_tile_stack:
func update_town() -> void:
	var player_tiles = Global.active_player.town_tiles
	for position in player_tiles.keys():
		set_cell(position.x, position.y, player_tiles[position])

# adds card to TileMap and town stack
# @param tile: - TileCard received from market/spare tiles
# @param x: - TileMap local x coordinate
# @param y: - TileMap local y coordinate
func place_tile(x: int, y: int, tile: TileCard):
	set_cell(x, y, tile.get_id())
	Global.active_player.add_town_tile(tile, Vector2(x, y))

	var nwall = longest_wall()
	if nwall: OverlayDebugInfo.set_label("Wall Length",  "Wall Length: " + nwall as String)

# remove tile from TileMap and town stack and returns its id
# @param x: - TileMap local x coordinate
# @param y: - TileMap local y coordinate
func remove_tile(x: int, y: int) -> int:
	var tile_id = get_cell(x, y)
	Global.active_player.remove_town_tile(Vector2(x, y))
	set_cell(x, y, TileMap.INVALID_CELL)
	print_debug("Removed tile %d at (%d|%d)" % [tile_id, x, y])
	return tile_id

# check if removing this tile would break continouity of town
# @param x: - TileMap local x coordinate
# @param y: - TileMap local y coordinate
func _is_tile_removable(x: int, y: int) -> bool:

	var removal_valid = true
	var test_id = get_cell(x, y)

	# if tile is not populated or starting tile, removal not valid
	if test_id == TileMap.INVALID_CELL || test_id == _starting_tile_id: return false

	# check if removal would leave hole, happens if all four neighbours are present
	if _count_neighbours(x, y) == 4:
		return false

	# remove test tile and neighbour then check if neighbour placement is still valid
	set_cell(x, y, TileMap.INVALID_CELL)

	# if any tile has infinite distance, the connection to start was broken
	_update_distancemap(_distances)
	if !_distances.get_used_cells_by_id(_max_int).empty():
		removal_valid = false

	# loop over each neighbour, for each neighbour check if placement is still valid, with test tile remove
	for neighbour in get_neighbours(x, y):
		var neighbour_id = get_cellv(neighbour)
		# if neighbour tile is empty or starting tile, removal is valid regarding this neighbour
		if neighbour_id != TileMap.INVALID_CELL:
			set_cellv(neighbour, TileMap.INVALID_CELL)
			# if neighbour tile can not be placed removal of test tile not valid
			if !is_placement_valid(neighbour.x, neighbour.y, neighbour_id):
				removal_valid = false
			# readd neighbour tile
			set_cellv(neighbour, neighbour_id)

	set_cell(x, y, test_id) # readd test tile
	_update_distancemap(_distances) # recalculate distances for restored town

	return removal_valid

# returns number of occupied neighbour tiles
# @param x: - TileMap local x coordinate
# @param y: - TileMap local y coordinate
func _count_neighbours(x: int, y: int) -> int:
	return get_neighbours(x, y).size()

func place_starting_tile() -> void:
	var start_x = floor(_max_size[0] / 2)
	var start_y = floor(_max_size[1] / 2)
	var start_id = _starting_tile_id
	set_cell(start_x, start_y, start_id)

# checks if tile specified by id can be placed at (x, y)
# @param x: - TileMap local x coordinate
# @param y: - TileMap local y coordinate
# @param id: - cell ID to place
func is_placement_valid(x: int, y: int, id: int) -> bool:

	var placement_valid = false
	var double_wall = false
	var has_connection = false

	# if tile is already populated return false
	if get_cell(x, y) != TileMap.INVALID_CELL: return false

	# starting tile can always be placed if position is empty
	if id == _starting_tile_id: return true

	# can not be placed without neighbours
	if _count_neighbours(x, y) == 0: return false

	# check if placing tiles would create hole:
	# preliminarily set tile
	set_cell(x, y, id)
	# if not all invalid cells are connected to each other, a hole was created
	_update_distancemap(_inverse_distances, true)
	var hole_created = !_inverse_distances.get_used_cells_by_id(_max_int).empty()
	# clear test tile
	set_cell(x, y, TileMap.INVALID_CELL)
	if hole_created:
		return false

	# check if there is any connection and if walls block placement:
	# loop over all tiles surrounding position, including invalid ones
	for neighbour in get_neighbours(x, y, true):
		var neighbour_id = get_cellv(neighbour)

		# if neighbour is not empty, check for walls
		if neighbour_id != TileMap.INVALID_CELL: # if neighbour tile is not empty

			placement_valid = true # if tile has a neighbour it is possibly true

			# how many walls are there between neighbour and tile to place?
			# 0 -> placement possible, 1 -> impossible, 2 -> maybe possible if another connection exists where there are no walls
			match walls_between(Vector2(x, y), neighbour, id):
				0: has_connection = true
				1: return false
				2: double_wall = true

	if double_wall: return has_connection # placement possible if another connection exists where there are no walls
	return placement_valid

# returns the number of walls between two tiles
# @param pos1: - Vector2 containing position of first tile
# @param pos2 - Vector2 containing position of second tile
# @param id: - optional id if pos2 is empty but a check is needed as if a tile with this id had been set there
func walls_between(pos1: Vector2, pos2: Vector2, id1 = -1, id2 = -1) -> int:

	if id1 == -1: id1 = get_cellv(pos1) # if no id was passed, get it town map
	if id2 == -1: id2 = get_cellv(pos2) # if no id was passed, get it town map

	# if one tile is empty walls do not matter, return zero walls for convenience in calls
	if id1 == TileMap.INVALID_CELL && id2 == TileMap.INVALID_CELL:
		return 0

	# get corresponding TileCards
	var card1 = _reference_tiles.get_card_info_by_id(id1)
	var card2 = _reference_tiles.get_card_info_by_id(id2)

	# get direction from card1 to card2, only for neighbouring tiles
	var direction
	if pos1.x - pos2.x == -1:
		direction = "RIGHT"
	elif pos1.x - pos2.x == 1:
		direction = "LEFT"
	elif pos1.y - pos2.y == 1:
		direction = "UP"
	elif pos1.y - pos2.y == -1:
		direction = "DOWN"

	var walls1 = card1.get_enabled_walls()
	var walls2 = card2.get_enabled_walls()
	match direction:
		"UP":
			if walls1.TOP or walls2.BOTTOM:
				if walls1.TOP and walls2.BOTTOM: return 2 # both tiles have walls
				else: return 1 # only one tile has wall
		"DOWN":
			if walls1.BOTTOM or walls2.TOP:
				if walls1.BOTTOM and walls2.TOP: return 2
				else: return 1
		"RIGHT":
			if walls1.RIGHT or walls2.LEFT:
				if walls1.RIGHT and walls2.LEFT: return 2
				else: return 1
		"LEFT":
			if walls1.LEFT or walls2.RIGHT:
				if walls1.LEFT and walls2.RIGHT: return 2
				else: return 1

	return 0


# updates the overlay for possible tile placement in regards to the tile you want to place
func update_overlay(border: Rect2, id_compare: int = _starting_tile_id) -> void:

	_tilemap_overlay.clear()
	cleanup_placed_tiles(_tilemap_overlay)

	# consider all tiles within the rectangle spanned by current tiles plus one in each direction
	for x in range(border.position.x - 1, border.position.x + border.size.x + 1):
		for y in range(border.position.y - 1, border.position.y + border.size.y + 1):
			# set cells according to valid/invalid
			if is_placement_valid(x, y, id_compare ):
				draw_tile(_tilemap_overlay, x, y, id_compare)


# can be used for preview as well as for actual placement
# @param tile_map: TileMap - Which TileMap to draw on - Town or Overlay
# @param x: - TileMap local x coordinate
# @param y: - TileMap local y coordinate
# @param card_id: - Card ID, which is usually also the cell ID
func draw_tile(tile_map: TileMap, x, y, card_id):
	var tile = _reference_tiles.get_card_info_by_id(card_id)
	var tile_node = tile_card_scene.instance()
	tile_node._card_info = tile

	var world_position = tile_map.map_to_world(Vector2(x, y))
	tile_node.set_position(world_position)
	tile_node.set_scale(Vector2(0.5, 0.5))

	# Do not capture mouse clicks, as the clicks will be handled by the TileMap
	tile_node.mouse_filter = Control.MOUSE_FILTER_IGNORE

	tile_map.add_child(tile_node)


# can be used for preview overlay as well as for actual placement
# @param tile_map: TileMap - Which TileMap to remove from - Town or Overlay
func cleanup_placed_tiles(tile_map: TileMap):
	# Remove all Cards which are already here to be drawn:
	var children = tile_map.get_children()
	for child in children:
		if child is TileCardDrawable:
			tile_map.remove_child(child)
			child.free()

# draw placed tiles
func draw_placed_tiles() -> void:
	# TODO: Optimimize process, only remove/draw neccessary tiles
	cleanup_placed_tiles(self)

	# Redraw
	var border = _get_border()
	for x in range(border.position.x, border.position.x + border.size.x):
		for y in range(border.position.y, border.position.y + border.size.y):
			var card_id = get_cell(x, y)
			if card_id != TileMap.INVALID_CELL:
				draw_tile(self, x, y, card_id)
	return


# should be called when tile is selected in market
func receive_tile(tile: TileCardDrawable):
	_current_tile = tile._card_info

	update_overlay(_get_border(), _current_tile._id)
	self._placement_mode = 1

# get rectangle spanned by already placed tiles
func _get_border():
	return get_used_rect()

# updates _distances, containing distance to starting tile along shortest path
# implentation of dijkstra algorithm, with all paths equal one
# @param invert: if true, connections between empty cells are checked instead of town tiles
func _update_distancemap(distancemap: TileMap, invert = false) -> void:

	# set all distances impossibly high where a towntile is present
	distancemap.clear()

	# fill all positions of town tiles with very large distances
	var tilepositions  = self.get_used_cells() # returns a Vector2 containing positions of filled town spaces
	for pos in tilepositions:
		distancemap.set_cell(pos.x, pos.y, _max_int)
	var starting_position = get_used_cells_by_id(_starting_tile_id)[0]

	# if inverse path is calculated, flip all tiles within a rectangle around town
	var border = _get_border()
	if invert:
		for _x in range(border.position.x - 1, border.position.x + border.size.x + 1):
			for _y in range(border.position.y - 1, border.position.y + border.size.y + 1):
				if distancemap.get_cell(_x, _y) == TileMap.INVALID_CELL:
					distancemap.set_cell(_x, _y, _max_int)
				else:
					distancemap.set_cell(_x, _y, TileMap.INVALID_CELL)
		# in this case starting position is upper left corner
		starting_position = Vector2(border.position.x - 1, border.position.y - 1)

	# starting tile has zero distance to itself
	distancemap.set_cell(starting_position.x, starting_position.y, 0)

	# loop over steps from starting tile, max number of steps is less than number of tiles, times three for inverse paths
	for step  in range(0, tilepositions.size()*30):
		# loop over all positions with distance step from starting tile
		for pos in distancemap.get_used_cells_by_id(step):
			# loop over its neighburs
			for neighbour in get_neighbours(pos.x, pos.y, true):
				# check if distance is unassigned, all assigned distances are always the shortest because all paths are length one
				if distancemap.get_cellv(neighbour) == _max_int:
					# path
					if invert:
						distancemap.set_cellv(neighbour, step + 1)
					elif walls_between(pos, neighbour) == 0:
						distancemap.set_cellv(neighbour, step + 1)

	return

# returns array ov Vector2 with positions of all valid neighbours to position (x, y)
func get_neighbours(x: int, y: int, include_empty_cells = false):

	var neighbours = []
	# loop over all tiles surrounding position (including itself)
	for _x in range(-1, 2):
		for _y in range(-1, 2):
			if abs(_x) != abs(_y): # leaves only tiles neighbouring up, down, left and right
				# if tile is not empty, add position to return array
				if include_empty_cells:
					neighbours.append(Vector2(x + _x, y + _y))
				elif get_cell(x + _x, y + _y) != TileMap.INVALID_CELL:
					neighbours.append(Vector2(x + _x, y + _y))

	return neighbours

# get length of longest wall in town
func longest_wall() -> int:
	# Tilemaps that count outgoing walls for each corner, positions represent corners, and id represents how many walls are in the corresponding direction
	var map_right = TileMap.new()
	var map_left = TileMap.new()
	var map_up = TileMap.new()
	var map_down = TileMap.new()

	# create array of positions that contain town tiles
	var wall_centers = get_used_cells()

	var delta = 1 # arbitrary integer unequal zero, was not sure if 1 would work because of invalidcell = -1
	# for all tiles, if there are walls, increment the direction layers at the corresponding corner
	for position in wall_centers:
		# get walls for this position
		var wall_sides = _reference_tiles.get_card_info_by_id(get_cellv(position)).get_enabled_walls()

		# corners of tile, left upper gets same indices as tile center in town map
		var leftupper = position
		var leftlower = Vector2(position.x, position.y + 1)
		var rightupper = Vector2(position.x + 1, position.y)
		var rightlower = Vector2(position.x + 1, position.y + 1)

		if wall_sides.TOP:
			increment_tile(map_right, leftupper, delta)
			increment_tile(map_left, rightupper, delta)
		if wall_sides.RIGHT:
			increment_tile(map_down, rightupper, delta)
			increment_tile(map_up, rightlower, delta)
		if wall_sides.BOTTOM:
			increment_tile(map_right, leftlower, delta)
			increment_tile(map_left, rightlower, delta)
		if wall_sides.LEFT:
			increment_tile(map_down, leftupper, delta)
			increment_tile(map_up, leftlower, delta)

	# get array of all corners that have a wall connection, remove multiple entries
	var corners_with_wall = map_right.get_used_cells() + map_left.get_used_cells() + map_up.get_used_cells() + map_down.get_used_cells()
	corners_with_wall = array_unique(corners_with_wall)

	# walls can start only at corners with one or three walls
	var starting_positions: Array = []
	for position in corners_with_wall:
		# add all connections from the direction layers, plus four is because the addition of walls to e.g. map_right started with INVALID_CELL (= -1)
		var wall_count = (map_right.get_cellv(position) + map_left.get_cellv(position) + map_up.get_cellv(position) + map_down.get_cellv(position) + 4) / delta
		# if wall count is even, wall can not start here
		if  wall_count % 2 != 0:
			starting_positions.append(position)



	# start at each starting position and follow along the wall until end is reached
	# this implemantation counts every wall twice, but was easier to implement
	var lengths = [0] # array that will store all wall lengths
	for position in starting_positions:
		var count = 0 # count steps for wall length
		var ended = false # triggers when no further connection can be found
		var current_position = position # position that travels along the wall
		var last_direction = -1 # needed to avoid going back and forth on same wall segment

		while ended == false:
			count = count + 1
			# if node has a connection in a certain direction take that path if you did not come from that direction
			# and there is no double wall. Second condition is equal to exactly one delta in direction layer (-1 for starting with invalid cell)


			if map_right.get_cellv(current_position) == delta - 1 && last_direction != TileCard.WallDirection.LEFT:
				last_direction = TileCard.WallDirection.RIGHT
				current_position.x = current_position.x + 1
			elif map_left.get_cellv(current_position) == delta - 1 && last_direction != TileCard.WallDirection.RIGHT:
				current_position.x = current_position.x - 1
				last_direction = TileCard.WallDirection.LEFT
			elif map_up.get_cellv(current_position) == delta - 1 && last_direction != TileCard.WallDirection.DOWN:
				current_position.y = current_position.y - 1
				last_direction = TileCard.WallDirection.UP
			elif map_down.get_cellv(current_position) == delta - 1 && last_direction != TileCard.WallDirection.UP:
				current_position.y = current_position.y + 1
				last_direction = TileCard.WallDirection.DOWN
			else:
				ended = true
				count = count - 1 # if nothing is found count is to high

		# add steps for this starting_position
		lengths.append(count)

	# return length of longest wall
	return int(lengths.max())

func increment_tile(map: TileMap, position: Vector2, delta: int):
	map.set_cellv(position, map.get_cellv(position) + delta)
	return

# get array with multiples of entries removed
func array_unique(array: Array) -> Array:
	var unique: Array = []

	for item in array:
		if not unique.has(item):
			unique.append(item)
	return unique

# debug functions
func _on_TextureButton_pressed():
	#DEBUG
	var id = _starting_tile_id
	id = randi() % 30 +1
	_current_tile = TileCard.new(id, 0, TileCard.TileType.START, TileCard.WALL_SIDE_NONE)
	OverlayDebugInfo.set_label("Tile ID",  "Tile ID: "+ _current_tile.get_id() as String)
	_get_border()
	update_overlay(_get_border(), _current_tile._id)
	self._placement_mode = (_placement_mode + 1) % 3
	print_debug(_placement_mode)
	draw_placed_tiles()
	yield(get_tree().create_timer(0.5), "timeout")

	var nwall = longest_wall()
	if nwall: OverlayDebugInfo.set_label("Wall Length",  "Wall Length: " + nwall as String)


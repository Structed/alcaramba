extends TileMap

# Receives a TileCard, VEcto2 position
signal tile_placed

var _stack_tiles: TileCardCollection = TileCardCollection.new() # complete stack for tile info
var _town_tiles: TileCardCollection = TileCardCollection.new() # stack for acually placed tiles
var _starting_tile_id = 54
var _current_tile: TileCard = TileCard.new(_starting_tile_id, 0, TileCard.TileType.START, TileCard.WALL_SIDE_NONE)
var _max_size = [10, 10]
var _placement_mode : int = 0 setget _placement_mode_set # 0 = no placement, 1 = place tile, 2 = remove tile

onready var _tilemap_overlay = get_node("%TileMap_valid_overlay")

var tile_card_scene = preload("res://Drawable/Card/TileCardDrawable.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	_stack_tiles.initialize_for_game_start() # Implement Player stack and handover/keeping of tiles
	_stack_tiles.add_card(_current_tile)
	self._placement_mode = 0
	_town_tiles.add_card(_current_tile)
	place_starting_tile()
	$TileMap_valid_overlay.hide()
	draw_placed_tiles()

	OverlayDebugInfo.show()
	OverlayDebugInfo.set_horizontal_align_right()
	OverlayDebugInfo.set_vertical_align_top()


# Called every frame
func _process(_delta):

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


func _input(event):
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
				if cell_to_remove != TileMap.INVALID_CELL && cell_to_remove != _starting_tile_id && is_tile_removable(x, y):
					var removed_tile_id = remove_tile(x, y)
					# TODO #19: send tile to spare tiles
					draw_placed_tiles()


func place_tile(x: int, y: int, tile: TileCard):
	# if is_placement_valid(x,y,tile.get_id()):
	set_cell(x, y, tile.get_id())
	_town_tiles.add_card(tile)
	emit_signal("tile_placed", tile, Vector2(x, y))

func remove_tile(x: int, y: int) -> int:
	var tile_id = get_cell(x, y)
	_stack_tiles.remove_card_by_id(tile_id)
	set_cell(x, y, TileMap.INVALID_CELL)
	print_debug("Removed tile %d at (%d|%d)" % [tile_id, x, y])
	return tile_id

# check if removing this tile would break continouity of town
func is_tile_removable(x: int, y: int):
	# TODO #15: logic for continuity
	return true

func place_starting_tile() -> void:
	var start_x = floor(_max_size[0] / 2)
	var start_y = floor(_max_size[1] / 2)
	var start_id = _starting_tile_id
	set_cell(start_x, start_y, start_id)

# checks if tile specified by id can be placed at (x,y)
func is_placement_valid(x: int, y: int, id: int) -> bool:

	var placement_valid = false
	var double_wall = false
	var has_connection = false

	# if tile is already populated return false
	if get_cell(x, y) != TileMap.INVALID_CELL: return false

	var center_card = _stack_tiles.get_card_info_by_id(id) # card to place

	# loop over all tiles surrounding position (including itself)
	for _x in range(-1, 2):
		for _y in range(-1, 2):
			if abs(_x) != abs(_y): # leaves only tiles neighbouring up, down, left and right
				var current_cell = get_cell(x + _x, y + _y)
				if current_cell != TileMap.INVALID_CELL: # if neighbour tile is not empty

					placement_valid = true # if tile has a neighbour it is possibly true

					var next_card = _stack_tiles.get_card_info_by_id(current_cell)
					# direction from tile to place to its neighbour
					var direction = ""
					if _x == -1: direction = "LEFT"
					if _x ==  1: direction = "RIGHT"
					if _y ==  1: direction = "DOWN"
					if _y == -1: direction = "UP"

					# are there walls between the two tiles?
					# 0 -> placement possible, 1 -> impossible, 2 -> maybe possible if other connection exists and is 0
					match walls_between(center_card, next_card, direction):
						0: has_connection = true
						1: return false
						2: double_wall = true
					
	if double_wall: return has_connection
	return placement_valid

# number of walls between tiles
func walls_between(card1: TileCard, card2: TileCard, direction: String)-> int:
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
func update_overlay(border: Rect2, id_compare: int = 6) -> void:

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
	var tile = _stack_tiles.get_card_info_by_id(card_id)
	var tile_node = tile_card_scene.instance()
	tile_node._card_info = tile

	var world_position = tile_map.map_to_world(Vector2(x, y))
	tile_node.set_position(world_position)
	tile_node.set_scale(Vector2(0.5, 0.5))
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


# should be called when tile is selected in market
func receive_tile(tile: TileCardDrawable):
	_current_tile = tile._card_info

	update_overlay(_get_border(), _current_tile._id)
	self._placement_mode = 1

# get rectangle spanned by already placed tiles
func _get_border():
	return get_used_rect()


# debug functions
func _on_TextureButton_pressed():
	#DEBUG
	var id = _starting_tile_id
	while _town_tiles.get_card_info_by_id(id) != null:
		id = randi() % 30 +1
	_current_tile = TileCard.new(id, 0, TileCard.TileType.START, TileCard.WALL_SIDE_NONE)
	OverlayDebugInfo.set_label("Tile ID",  "Tile ID: "+ _current_tile.get_id() as String)
	_get_border()
	update_overlay(_get_border(), _current_tile._id)
	self._placement_mode = (_placement_mode + 1) % 3
	print_debug(_placement_mode)
	draw_placed_tiles()

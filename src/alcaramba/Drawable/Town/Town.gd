extends TileMap

var _stack_tiles: TileCardCollection = TileCardCollection.new()
var _starting_tile_id = 6
var _current_tile: TileCard = TileCard.new(_starting_tile_id, 0, TileCard.TileType.START, TileCard.WALL_SIDE_NONE)
var _max_size = [10, 10]
var _placement_mode : int = 0 setget _placement_mode_set # 0 = no placement, 1 = place tile, 2 = remove tile

var tile_card_scene = preload("res://Drawable/Card/TileCardDrawable.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#_stack_tiles.initialize_for_game_start() # Implement Player stack and handover/keeping of tiles
	self._placement_mode = 0
	_stack_tiles.add_card(TileCard.new(_starting_tile_id, 0, TileCard.TileType.START, TileCard.WALL_SIDE_NONE))
	place_starting_tile()
	$TileMap_valid_overlay.hide()
	draw_placed_tiles()


# Called every frame
func _process(_delta):

	if _placement_mode != 0:
		# TODO: confine mouse to town?
		pass

	if _placement_mode == 1:
		$TileMap_valid_overlay.show()
	else:
		$TileMap_valid_overlay.hide()


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
					update_overlay(_get_border(), _current_tile._id)
					draw_placed_tiles()

			# left click and removing mode
			if event.button_index == 1 && _placement_mode == 2:
				# if cell not empty and cell is not starting tile and removed does not break connection
				var cell_to_remove = get_cell(x, y)
				if cell_to_remove != TileMap.INVALID_CELL && cell_to_remove != _starting_tile_id && is_tile_removable(x, y):
					var removed_tile_id = remove_tile(x, y)
					#TODO 19: send tile to spare tiles
					draw_placed_tiles()


func place_tile(x: int, y: int, tile: TileCard):
	# if is_placement_valid(x,y,tile.get_id()):
	set_cell(x, y, tile.get_id())

func remove_tile(x: int, y: int) -> int:
	var tile_id = get_cell(x, y)
	_stack_tiles.remove_card_by_id(tile_id)
	set_cell(x, y, TileMap.INVALID_CELL)
	print_debug("Removed tile %d at (%d|%d)" % [tile_id, x, y])
	return tile_id

# check if removing this tile would break continouity of town
func is_tile_removable(x: int, y: int):
	# TODO 15: logic for continuity
	return true

func place_starting_tile() -> void:
	var start_x = floor(_max_size[0] / 2)
	var start_y = floor(_max_size[1] / 2)
	var start_id = _starting_tile_id
	set_cell(start_x, start_y, start_id)

# checks if tile specified by id can be placed at (x,y)
func is_placement_valid(x: int, y: int, id: int) -> bool:

	var placement_valid = false

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

					# is there a wall between the two tiles
					if is_wall(center_card, next_card, direction):
						return false
	return placement_valid

# checks if there is a wall between two tiles in a given direction, wall can be on either tile
func is_wall(card1: TileCard, card2: TileCard, direction: String)-> bool:
	var walls1 = card1.get_enabled_walls()
	var walls2 = card2.get_enabled_walls()
	match direction:
		"UP":
			return walls1.TOP or walls2.BOTTOM
		"DOWN":
			return walls1.BOTTOM or walls2.TOP
		"RIGHT":
			return walls1.RIGHT or walls2.LEFT
		"LEFT":
			return walls1.LEFT or walls2.RIGHT

	return false


# updates the overlay for possible tile placement in regards to the tile you want to place
func update_overlay(border: Rect2, id_compare: int = 6) -> void:

	$TileMap_valid_overlay.clear()

	# consider all tiles within the rectangle spanned by current tiles plus one in each direction
	for x in range(border.position.x - 1, border.position.x + border.size.x + 1):
		for y in range(border.position.y - 1, border.position.y + border.size.y + 1):
			# set cells according to valid/invalid
			if is_placement_valid(x, y, id_compare ):
				$TileMap_valid_overlay.set_cell(x, y, 1)
			else:
				$TileMap_valid_overlay.set_cell(x, y, 0)


# draw placed tiles
func draw_placed_tiles() -> void:
	# TODO: Optimimize process, only remove/draw neccessary tiles

	# Remove all Cards which are already here to be drawn:
	var children = get_children()
	for child in children:
		if child is TileCardDrawable:
			remove_child(child)
			child.free()

	# Redraw
	var border = _get_border()
	for x in range(border.position.x, border.position.x + border.size.x):
		for y in range(border.position.y, border.position.y + border.size.y):
			var current_cell = get_cell(x, y)
			if current_cell != TileMap.INVALID_CELL:
				var tile = _stack_tiles.get_card_info_by_id(current_cell)
				var tile_node = tile_card_scene.instance()
				tile_node._card_info = tile

				var world_position = map_to_world(Vector2(x, y))
				tile_node.set_position(world_position)
				#tile_node.rect_scale(Vector2(0.5, 0.5))
				tile_node.set_scale(Vector2(0.5, 0.5))
				self.add_child(tile_node)


# should be called when tile is selected in market
func receive_tile(tile: TileCard):
	_stack_tiles.add_card(tile)
	_current_tile = tile

	update_overlay(_get_border(), _current_tile._id)
	self._placement_mode = 1

# get rectangle spanned by already placed tiles
func _get_border():
	return get_used_rect()


# debug functions
func _on_TextureButton_pressed():
	#DEBUG
	var id = -2
	#while id
	_current_tile = TileCard.new(randi() % 13 + 1, 0, TileCard.TileType.START, TileCard.WALL_SIDE_NONE)
	OverlayDebugInfo.set_label("Tile ID",  "Tile ID: "+ _current_tile.get_id() as String)
	_get_border()
	update_overlay(_get_border(), _current_tile._id)
	self._placement_mode = (_placement_mode + 1) % 3
	print_debug(_placement_mode)
	draw_placed_tiles()

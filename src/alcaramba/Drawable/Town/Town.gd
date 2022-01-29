extends TileMap

var _stack_tiles: TileCardCollection = TileCardCollection.new()
#var tile_card_scene = preload("res://Drawable/Card/TileCardDrawable.tscn")
var _starting_tile_id = 0
var _current_tile: TileCard = TileCard.new(_starting_tile_id, 0, TileCard.TileType.START, TileCard.WALL_SIDE_NONE)
var _max_size = [10,10]
var _placement_mode : int = 0 # 0 = no placement, 1 = place tile, 2 = remove tile


# Called when the node enters the scene tree for the first time.
func _ready():
	
	_stack_tiles.add_card(TileCard.new(_starting_tile_id, 0, TileCard.TileType.START, TileCard.WALL_SIDE_NONE))
	place_starting_tile()
	$TileMap_valid_overlay.hide()
	
# Called every frame
func _process(delta):
	if _placement_mode != 0:
		#TODO: confine mouse to town?
		pass
		
	if _placement_mode == 1:
		$TileMap_valid_overlay.show()
	else:
		$TileMap_valid_overlay.hide()
		
func _input(event):
	# if _placement_mode is set for placing or removing
	if _placement_mode != 0: 
		# if mouse is pressed
		if event is InputEventMouseButton && event.is_pressed():
			# get grid position
			var grid_position = world_to_map(get_local_mouse_position())
			var x = grid_position.x
			var y = grid_position.y
			
			#left click and placing mode
			if event.button_index==1 && _placement_mode == 1:
				if is_placement_valid(x, y, _current_tile._id):
					# place tile and leave placement mode
					place_tile(x, y, _current_tile)
					_placement_mode = 0
					update_overlay(_get_border(),_current_tile._id)
				
			# left click and removing mode 
			if event.button_index == 1 && _placement_mode == 2:
				# if cell not empty and cell is not starting tile and removed does not break connection
				if get_cell(x, y) != -1 && get_cell(x, y) != _starting_tile_id && is_tile_removable(x, y):
					var removed_tile_id = remove_tile(x, y)
					#TODO: send tile to spare tiles
					update_overlay(_get_border(),_current_tile._id)
					

func place_tile(x: int, y: int, tile: TileCard):
	#if is_placement_valid(x,y,tile.get_id()):
	set_cell(x, y, tile.get_id())

func remove_tile(x: int, y: int) -> int:
	var tile_id = get_cell(x, y)
	_stack_tiles.remove_card_by_id(tile_id)
	set_cell(x, y, -1)
	return tile_id
	
# check if removing this tile would break continouity of town
func is_tile_removable(x: int, y:int):
	# TODO: logic for continuity
	return true
	
func place_starting_tile() -> void:
	var start_x = floor(_max_size[0]/2)
	var start_y = floor(_max_size[1]/2)
	var start_id = _starting_tile_id
	set_cell(start_x, start_y, start_id)

# checks if tile specified by id can be placed at (x,y)	
func is_placement_valid(x: int, y: int, id: int) -> bool:
	
	var placement_valid = false
	
	# if tile is already populated return false
	if get_cell(x,y) != -1: return false

	var center_card = _stack_tiles.get_card_by_id(id) # card to place
	
	# loop over all tiles surrounding position (including itself)
	for _x in range(-1,2):
		for _y in range(-1,2):
			if abs(_x) != abs(_y): #leaves only tiles neighbouring up, down, left and right
				if get_cell(x+_x, y+_y) != -1: #if neighbour tile is not empty
					
					placement_valid = true # if tile has a neighbour it is possibly true
					
					var next_card = _stack_tiles.get_card_by_id(get_cell(x + _x, y + _y))
					# direction from tile to place to its neighbour
					var direction =""
					if _x == -1: direction = "LEFT"
					if _x ==  1: direction = "RIGHT"
					if _y == 1: direction = "DOWN"
					if _y ==  -1: direction = "UP"
					
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
		"DOWM":
			return walls1.BOTTOM or walls2.TOP
		"RIGHT":
			return walls1.RIGHT or walls2.LEFT 
		"LEFT":
			return walls1.LEFT or walls2.RIGHT
	
	return false

# updates the overlay for possible tile placement in regards to the tile you want to place
func update_overlay(border: Rect2, id_compare: int = 6):
	
	$TileMap_valid_overlay.clear()
	
	# consider all tiles within the rectangle spanned by current tiles plus one in each direction
	for x in range(border.position.x - 1, border.position.x + border.size.x+1): 
		for y in range(border.position.y - 1, border.position.y + border.size.y+1):
			# set cells according to valid/invalid
			if is_placement_valid(x, y, id_compare ):
				$TileMap_valid_overlay.set_cell(x,y,1)
			else:
				$TileMap_valid_overlay.set_cell(x,y,0)
				
# should be called when tile is selected in market
func receive_tile(tile: TileCard):
	_stack_tiles.add_card(tile)
	_current_tile = tile
	
	update_overlay(_get_border(),_current_tile._id)
	_placement_mode = 1

# get rectangle spanned by already placed tiles
func _get_border():
	return get_used_rect()
	

# debug functions
func _on_TextureButton_pressed():
	#DEBUG
	_current_tile = TileCard.new(randi() % 13 + 1, 0, TileCard.TileType.START, TileCard.WALL_SIDE_NONE)
	_get_border()
	update_overlay(_get_border(),_current_tile._id)
	_placement_mode = (_placement_mode + 1) % 3
	print(_placement_mode)

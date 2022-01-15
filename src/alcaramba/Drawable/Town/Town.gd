extends TileMap

var _stack_tiles: TileCardCollection = TileCardCollection.new()
#var tile_card_scene = preload("res://Drawable/Card/TileCardDrawable.tscn")
var _current_tile: TileCard = TileCard.new(-1, 0, TileCard.TileType.START, TileCard.WALL_SIDE_NONE)


# Called when the node enters the scene tree for the first time.
func _ready():
	place_starting_tile()
	
func _input(event):
	# current tile is not empty
	if _current_tile: 
		# if mouse is pressed
		if event is InputEventMouseButton && event.is_pressed():
			# get grid position
			var grid_position = world_to_map(event.position)
			var x = grid_position.x
			var y = grid_position.y
			
			#left click
			if event.button_index==1:
				#TODO check if tile is already on board
				print(is_placement_valid(x, y, _current_tile._id))
				place_tile(x, y, _current_tile)
				update_overlay(_get_border(),_current_tile._id)
				
				# right click
			if event.button_index==2 && get_cell(x, y) != -1: #right click and tile not empty
				remove_tile(x,y)
				update_overlay(_get_border(), _current_tile._id)

func place_tile(x: int, y: int, tile: TileCard):
	#if is_valid_placement(x,y,tile):
	set_cell(x, y, tile.get_id())

func remove_tile(x: int, y: int) -> int:
	var tile_id = get_cell(x, y)
	set_cell(x, y, -1)
	return tile_id	
	
func is_valid_placement(x: int, y: int , tile: TileCard):
	var tile_id = get_cell(x, y)
	tile.get_enabled_walls()
	#unfinished TODO
	
# debug functions
func _get_border():
	return get_used_rect()

func _on_TextureButton_pressed():
	#DEBUG
	_current_tile = TileCard.new(randi()%13+1, 0, TileCard.TileType.START, TileCard.WALL_SIDE_NONE)
	_get_border()
	print(_current_tile._id)
	
func place_starting_tile() -> void:
	var start_x = 7
	var start_y = 8
	var start_id = 6
	set_cell(start_x, start_y, start_id)
	
func is_placement_valid(x: int, y: int, id: int) -> bool:
	
	var placement_valid = false
	
	# if tile is already populated return false
	if get_cell(x,y)!=-1: return false

	var center_card = _stack_tiles.get_card_by_position(id) # card to place
	
	# loop over all tiles surrounding position (including itself)
	for _x in range(-1,2):
		for _y in range(-1,2):
			if abs(_x) != abs(_y): #leaves only tiles neighbouring up, down, left and right
				if get_cell(x+_x, y+_y) !=-1: #if neighbour tile is not empty
					
					placement_valid = true # if tile has a neighbour it is possibly true
					
					var next_card = _stack_tiles.get_card_by_position(get_cell(x+_x, y+_y))
					var direction =""
					if _x == -1: direction = "LEFT"
					if _x ==  1: direction = "RIGHT"
					if _y == 1: direction = "DOWN"
					if _y ==  -1: direction = "UP"
					var a = get_cell(x+_x, y+_y)
					var b = is_wall(center_card, next_card, direction)
					
					# is there a wall between the two tiles
					if is_wall(center_card, next_card, direction): 
						return false

	return placement_valid
	
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

func update_overlay(border: Rect2, id_compare: int = 6):
	for x in range(border.position.x-1, border.position.x+border.size.x+1):
		for y in range(border.position.y-1, border.position.y+border.size.y+1):
			if is_placement_valid(x, y, id_compare ):
				$TileMap_valid_overlay.set_cell(x,y,1)
			else:
				$TileMap_valid_overlay.set_cell(x,y,0)



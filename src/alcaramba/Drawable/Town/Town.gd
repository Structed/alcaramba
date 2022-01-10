extends TileMap

var stack_tiles: TileCardCollection = TileCardCollection.new()
var tile_card_scene = preload("res://Drawable/Card/TileCardDrawable.tscn")
var current_tile: TileCard


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _input(event):
	if current_tile:
		if event is InputEventMouseButton && event.is_pressed():
			var grid_position = world_to_map(event.position)
			var x = grid_position.x
			var y = grid_position.y
			
			if event.button_index==1:				
				place_tile(x, y, current_tile)
			if event.button_index==2 && get_cell(x, y) != -1: #right click and tile not empty
				remove_tile(x,y)

func place_tile(x: int, y: int, tile: TileCard):
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
	print_debug(get_used_rect())

func _on_TextureButton_pressed():
	current_tile = stack_tiles.draw_card() #DEBUG
	place_tile(randi()%13, randi()%12, current_tile)
	_get_border()



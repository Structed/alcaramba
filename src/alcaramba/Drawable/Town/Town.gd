extends TileMap

var stack_tiles: TileCardCollection = TileCardCollection.new()
var tile_card_scene = preload("res://Drawable/Card/TileCardDrawable.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _create_tiles():
	tile_set.clear()
	for _i in range(stack_tiles.get_card_count() ):
		tile_set.create_tile(_i)
		var current_tile = stack_tiles.draw_card()
		var texture = Texture
		#tile_set.tile_set_texture(_i, stack_tiles.draw_card())


func place_tile(x: int, y: int, tile: TileCard):
	var id = tile.get_id()
	set_cell(x, y, tile.get_id())



func _on_TextureButton_pressed():
	place_tile(randi()%30, randi()%20, stack_tiles.draw_card())


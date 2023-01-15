extends VBoxContainer

signal tile_card_selected

var _stack_spare_tiles: TileCardCollection = TileCardCollection.new() # contains tiles placed on spare
var _displayed_tiles: int = 0

var tile_scene = preload("res://Drawable/Card/TileCardDrawable.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# paints all tiles from stack_spare_tiles
func _display_tiles():
	# delete already displayed tiles
	for n in self.get_children():
		n.queue_free()
	# create new TileCardDrawable for each til in stack_spare_tiles
	for _i in range(_stack_spare_tiles.get_card_count()):
		var tile_node = tile_scene.instance()
		tile_node._card_info = _stack_spare_tiles.get_card_info_by_index(_i)
		add_child(tile_node)
		tile_node.connect("pressed", self, "_on_TileCard_pressed", [tile_node])

func _on_TileCard_pressed(tile_node: TileCardDrawable):
	tile_node.select()
	emit_signal("tile_card_selected", tile_node)

# removed tile from town is added to spare parts
func _on_TileMap_tile_removed(tile: TileCard):
	_stack_spare_tiles.add_card(tile)
	_display_tiles()

# if placed tile came frome spare remove it from its stack, position is not needed here but emitted for other calls
func _on_TileMap_tile_placed(tile: TileCard, _position: Vector2):
	_stack_spare_tiles.remove_card_by_id(tile.get_id())
	_display_tiles()

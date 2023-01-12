extends Node

onready var _town = get_node("%Town")

var _selected_tile: TileCardDrawable
onready var _market := get_node("%Market")


# Called when the node enters the scene tree for the first time.
func _ready():
	OverlayDebugInfo.show()
	OverlayDebugInfo.set_horizontal_align_right()
	OverlayDebugInfo.set_vertical_align_top()


	$Market.get_node("TileMarket").connect("tile_card_selected", self, "_on_tile_card_selected")
	_town.get_node("SpareTiles").connect("tile_card_selected", self, "_on_tile_card_selected")



func _on_tile_card_selected(card_node: TileCardDrawable):
	# If another tile was clicked, we need to first reset the previous tile
	if _selected_tile != null && card_node != _selected_tile:
		_selected_tile.reset()

	_selected_tile = card_node
	if _town.is_connected("tile_placed", self, "_on_tile_placed"):
		_town.disconnect("tile_placed", self, "_on_tile_placed")
	_town.connect("tile_placed", self, "_on_tile_placed")
	_town.receive_tile(_selected_tile)
	_selected_tile.select()


func _on_tile_placed(tile: TileCard, position: Vector2):
	Global.active_player.add_town_tile(tile, position)
	_selected_tile.clear()

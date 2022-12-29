extends Node

onready var _town = get_node("%Town")

var _selected_tile: TileCardDrawable

# Called when the node enters the scene tree for the first time.
func _ready():
	OverlayDebugInfo.show()
	OverlayDebugInfo.set_horizontal_align_right()
	OverlayDebugInfo.set_vertical_align_top()


	$Market.get_node("TileMarket").connect("tile_card_selected", self, "_on_tile_card_selected")


func _on_tile_card_selected(card_node: TileCardDrawable):
	_selected_tile = card_node
	if _town.is_connected("tile_placed", self, "_on_tile_placed"):
		_town.disconnect("tile_placed", self, "_on_tile_placed")
	_town.connect("tile_placed", self, "_on_tile_placed")
	_town.receive_tile(card_node)
	$Market.self_modulate.a = 0.5


func _on_tile_placed(card_node: TileCard):
	Global.active_player.tile_cards_yard.add_card(card_node)
	_selected_tile._card_info = null
	_selected_tile.visible = false

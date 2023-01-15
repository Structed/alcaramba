extends Node

onready var _town = get_node("%Town")

var _selected_tile: TileCardDrawable
onready var _market := get_node("%Market")


# Called when the node enters the scene tree for the first time.
func _ready():

	_market.get_node("TileMarket").connect("tile_card_selected", self, "_on_tile_card_selected")
	_town.get_node("ContainerRight").get_node("SpareTiles").connect("tile_card_selected", self, "_on_tile_card_selected")


func _on_tile_card_selected(card_node: TileCardDrawable):
	# reset previously selected and assign new selected tile
	_deselect_tile()
	_selected_tile = card_node
	# connect signal to listen if tile has been placed
	if _town.is_connected("tile_placed", self, "_on_tile_placed"):
		_town.disconnect("tile_placed", self, "_on_tile_placed")
	_town.connect("tile_placed", self, "_on_tile_placed")
	# send selected tile to town for placement overlay
	_town.receive_tile(_selected_tile)
	# highlight selected tile
	_selected_tile.select()

# if tile is placed add it to town stack and remove selection
func _on_tile_placed(tile: TileCard, position: Vector2):
	Global.active_player.add_town_tile(tile, position)
	_selected_tile.clear()

# get to state with no selected tile, remove highlight if there was a previously selected tile
func _deselect_tile():
	if _selected_tile != null:
			_selected_tile.reset()
	_selected_tile = null

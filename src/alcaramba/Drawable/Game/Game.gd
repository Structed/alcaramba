extends Node

onready var _town = get_node("%Town")

var _selected_tile: TileCardDrawable
onready var _market := get_node("%Market")


# Called when the node enters the scene tree for the first time.
func _ready():
	# Bind to when a  card was selected in the Tile Market
	var _error = _market.connect("tile_card_selected", self, "_on_tile_card_selected")
	if _error:
		print_debug("Error while connecting signal ")

	_town.get_node("ContainerRight").get_node("SpareTiles").connect("tile_card_selected", self, "_on_tile_card_selected")


func _on_tile_card_selected(card_node: TileCardDrawable):
	# reset previously selected and assign new selected tile
	_deselect_tile()
	_selected_tile = card_node
	# connect signal to listen if tile has been placed
	if Global.active_player.is_connected("tile_placed", self, "_on_tile_placed"):
		Global.active_player.disconnect("tile_placed", self, "_on_tile_placed")
	Global.active_player.connect("tile_placed", self, "_on_tile_placed")

	# send selected tile to town for placement overlay
	_town.receive_tile(_selected_tile)
	# highlight selected tile
	_selected_tile.select()

# if tile is placed add it to town stack and remove selection
func _on_tile_placed():
	_selected_tile.clear()

# get to state with no selected tile, remove highlight if there was a previously selected tile
func _deselect_tile():
	if _selected_tile != null:
			_selected_tile.reset()
	_selected_tile = null

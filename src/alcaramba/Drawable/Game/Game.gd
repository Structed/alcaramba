extends Node


var _selected_tile: TileCardDrawable
onready var _market := get_node("%Market")
onready var _town = get_node("%Town")
onready var _spare_tiles = get_node("%SpareTiles")
onready var _spare_tile_add_button = get_node("%SpareTileAddButton")


# Called when the node enters the scene tree for the first time.
func _ready():
	# Bind to when a  card was selected in the Tile Market
	var _error = _market.connect("tile_card_selected", self, "_on_tile_card_selected")
	_error = _spare_tiles.connect("tile_card_selected", self, "_on_spare_selected")
	_error = Global.active_player.connect("tile_placed", _spare_tiles, "_on_TileMap_tile_placed")
	_error = _town.connect("tile_removed", _spare_tiles, "_on_add_to_spares")
	_error = Global.active_player.connect("added_tile_to_spare_yard", self, "_on_spare_added_to_player")

	if _error:
		print_debug("Error while connecting signal ")


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

	# Make the tile placable to the Spare Yard
	if _spare_tile_add_button.is_connected("pressed", _spare_tiles, "_on_add_to_spares"):
		_spare_tile_add_button.disconnect("pressed", _spare_tiles, "_on_add_to_spares")
	_spare_tile_add_button.connect("pressed", _spare_tiles, "_on_add_to_spares", [_selected_tile._card_info], CONNECT_ONESHOT)

	# highlight selected tile
	_selected_tile.select()

func _on_spare_selected(card_node: TileCardDrawable):
	# send selected tile to town for placement overlay
	_town.receive_tile(card_node)

# if tile is placed add it to town stack and remove selection
func _on_tile_placed(tile: TileCard):
	# Disconnect button so tile cannot be added to spares after placing them
	if _spare_tile_add_button.is_connected("pressed", _spare_tiles, "_on_add_to_spares"):
		_spare_tile_add_button.disconnect("pressed", _spare_tiles, "_on_add_to_spares")
	
	if _selected_tile != null:
		_selected_tile.clear()
	else:
		# Must be spare
		_spare_tiles.remove_spare(tile)

func _on_spare_added_to_player(_tile: TileCard):
	_selected_tile.clear()
	_town._placement_mode_set(0)

# get to state with no selected tile, remove highlight if there was a previously selected tile
func _deselect_tile():
	if _selected_tile != null:
		_selected_tile.reset()
	_selected_tile = null

extends VBoxContainer

# Receives a `TileCardDrawable` as parameter
signal tile_card_selected

# Receives a `TileCard` as parameter
signal tile_card_added

var tile_scene = preload("res://Drawable/Card/TileCardDrawable.tscn")

# paints all tiles from stack_spare_tiles
func _display_tiles():
	# delete already displayed tiles
	for n in self.get_children():
		n.queue_free()

	# create new TileCardDrawable for each til in stack_spare_tiles
	for _i in range(Global.active_player.tile_cards_yard.get_card_count()):
		var tile_node = tile_scene.instance()
		tile_node._card_info = Global.active_player.tile_cards_yard.get_card_info_by_index(_i)
		add_child(tile_node)
		tile_node.connect("pressed", self, "_on_TileCard_pressed", [tile_node])


# Event handler for when a TileCard in the Spare Yard is pressed.
#
# @visibility: private
# @param tile_node: TileCardDrawable - The Tile node that was pressed
func _on_TileCard_pressed(tile_node: TileCardDrawable):
	tile_node.select()
	emit_signal("tile_card_selected", tile_node)


# removed tile from town is added to spare parts
#
# @visibility: public
# @param tile: TileCard - The Tile Card to be placed in the yard
# @returns: void
func _on_add_to_spares(tile: TileCard):
	if tile == null:
		push_error("Tile passed to spare yard cannot be null!")
	Global.active_player.tile_cards_yard.add_card(tile)
	_display_tiles()
	emit_signal("tile_card_added", tile)


# If a tile is placed in town, remove it from its spare stack.
# If it came from market, it is not in spare stack and nothing happens.
# _position is included in signal for other uses but not used here
#
# @visibility: public
# @param tile: TileCard - The Tile Card to be placed in the yard
# @param position: Vector2 - The position of the Tile in Town
# @returns: void
func _on_TileMap_tile_placed(tile: TileCard, position: Vector2):
	var _err = Global.active_player.transfer_tile_spare_to_town(tile, position)

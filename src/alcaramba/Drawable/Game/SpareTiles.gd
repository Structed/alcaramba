extends VBoxContainer

# Receives a `TileCardDrawable` as parameter
signal tile_card_selected

var tile_scene = preload("res://Drawable/Card/TileCardDrawable.tscn")

var _cached_number_of_tiles = 0

# paints all tiles from stack_spare_tiles
func _process(_delta):
	if _cached_number_of_tiles != Global.active_player.tile_cards_yard.get_card_count():
		_cached_number_of_tiles = Global.active_player.tile_cards_yard.get_card_count()

		# delete already displayed tiles
		for n in self.get_children():
			n.queue_free()

		# create new TileCardDrawable for each til in stack_spare_tiles
		for tile in Global.active_player.tile_cards_yard.get_cards():
			var tile_node = tile_scene.instance()
			tile_node._card_info = tile
			add_child(tile_node)
			tile_node.connect("pressed", self, "_on_TileCard_pressed", [tile_node])

func remove_spare(tile: TileCard):
	for child in self.get_children():
		if child._card_info.get_id() == tile.get_id():
			child.queue_free()

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
	Global.active_player.add_tile_to_spare_yard(tile)


# If a tile is placed in town, remove it from its spare stack.
# If it came from market, it is not in spare stack and nothing happens.
# _position is included in signal for other uses but not used here
#
# @visibility: public
# @param tile: TileCard - The Tile Card to be placed in the yard
# @param position: Vector2 - The position of the Tile in Town
# @returns: void
func _on_TileMap_tile_placed(tile: TileCard):
	var _err = Global.active_player.remove_tile_from_spare_yard(tile)


# Cancel the Placement of the Spare
func _on_place_tile_canceled(tile_node: TileCardDrawable):
	tile_node.deselect()


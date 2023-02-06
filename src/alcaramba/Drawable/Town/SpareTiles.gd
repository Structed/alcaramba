extends VBoxContainer

signal tile_card_selected

var _stack_spare_tiles: TileCardCollection = TileCardCollection.new() # contains tiles placed on spare

var tile_scene = preload("res://Drawable/Card/TileCardDrawable.tscn")

# paints all tiles from stack_spare_tiles
func _display_tiles():
	# delete already displayed tiles
	for n in self.get_children():
		# Leave other controls there
		if n is TileCard:
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
# visibility: public
# @param tile: TileCard - The Tile Card to be placed in the yard
# @returns: void
func _on_add_to_spares(tile: TileCard):
	if tile == null:
		push_error("Tile passed to spare yard cannot be null!")
	_stack_spare_tiles.add_card(tile)
	_display_tiles()


# If a tile is placed in town, remove it from its spare stack. If it came from market, it is not in spare stack and nothing happens. 
# _position is included in signal for other uses but not used here
# @visibility: public
# @param tile: TileCard - The Tile Card to be placed in the yard
# @param _position: VEctor2 - Unused
# @returns: void
func _on_TileMap_tile_placed(tile: TileCard, _position: Vector2):
	_stack_spare_tiles.remove_card_by_id(tile.get_id())

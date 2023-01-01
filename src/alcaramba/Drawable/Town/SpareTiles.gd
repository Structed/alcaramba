extends VBoxContainer

var _stack_spare_tiles: TileCardCollection = TileCardCollection.new() # contains tiles placed on spare

var tile_scene = preload("res://Drawable/Card/TileCardDrawable.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	_stack_spare_tiles.initialize_for_game_start() # DEBUG
	# _display_tiles()

# STUB: paints all tiles from stack_spare_tiles
func _display_tiles():
	for _i in range(_stack_spare_tiles.get_card_count()):
		var tile_node = tile_scene.instance()
		tile_node._card_info = _stack_spare_tiles.get_card_info_by_index(_i)
		add_child(tile_node)
	
	
# delete after this
#
#signal money_card_selected
#
#
#func is_missing_cards():
#	return _get_active_money_card_count() < MAX_MONEY_MARKET_CARDS
#
#
#func _get_active_money_card_count() -> int:
#	return get_child_count()
#
#
#func refill():
#	var cards_to_refill_count = MAX_MONEY_MARKET_CARDS - _get_active_money_card_count()
#	for _i in range(cards_to_refill_count):
#		var card = Global.stack_money.take_card()
#		var card_node = card_scene.instance()
#		card_node._card_info = card
#		add_child(card_node)
#		card_node.connect("pressed", self, "_on_MoneyCard_pressed", [card_node])
#
#
#func _on_MoneyCard_pressed(card_node: MoneyCardDrawable):
#	card_node.disconnect("pressed", self, "_on_MoneyCard_pressed")
#	Global.active_player.money_cards.add_card(card_node._card_info)
#	remove_child(card_node)
#	emit_signal("money_card_selected", card_node)

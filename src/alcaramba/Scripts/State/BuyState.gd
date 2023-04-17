extends AbstractState
class_name BuyState

export var market_path: NodePath
onready var market : Market = get_node(market_path)
onready var tile_market: TileMarket = get_node(market_path).tile_market
onready var hand: HandDrawable = get_node(market_path).hand

var purchased_tiles := TileCardCollection.new()


# Override get_class
#
# @visibility: public
# @return: String
func get_class() -> String:
	return "BuyState"


# Enter State
# Initialize/reset
#
# @visibility: public
# @param _msg: Dictionary - parameters (ignored)
# @return: void
func enter(_msg := {}) -> void:
	for card_node in hand.get_children():
		card_node.enable_selectable()
		if _msg.has("card_node") && card_node == _msg["card_node"]:
			card_node.toggle_select()

	market.end_turn_button.connect("pressed", self, "_on_end_turn_pressed")
	market.end_turn_button.disabled = false

	for card_node in tile_market.get_children():
		card_node.connect("pressed", self, "_on_tile_pressed", [card_node])


# Exit State
#
# @visibility: public
# @return: void
func exit() -> void:
	market.end_turn_button.disconnect("pressed", self, "_on_end_turn_pressed")
	market.end_turn_button.disabled = true

	hand.deselect_all()

	for card_node in hand.get_children():
		card_node.disable_selectable()

	for card_node in tile_market.get_children():
		card_node.disconnect("pressed", self, "_on_tile_pressed")
		
	# Redraw the hand, in case something has changed
	hand.redraw()


# Handler for End Turn Button
#
# @visibility: private
# @return: void
func _on_end_turn_pressed() -> void:
	state_machine.transition_to("EndState")


func _on_tile_pressed(card_node: TileCardDrawable) -> void:
	# Determine the currency & amount of money needed to buy the selected Tile
	var amount = card_node._card_info._value
	var currency = card_node.currency # MoneyCard.Currency

	# Purchase the Tile, if enough selected
	var selected = hand.get_selected_cards_by_currency(currency)
	if selected.sum_amount() >= amount:
		for money in selected.get_cards():
			var id = money.get_id()
			var removed_count = Global.active_player.money_cards.remove_card_by_id(id)
			if removed_count != 1:
				push_error("Only one card with ID %d should have been removed, but %d were removed!" % [id, removed_count])
			purchased_tiles.add_card(card_node._card_info)
			card_node.clear()

	if selected.sum_amount() == amount:
		# Can buy again!
		state_machine.transition_to("StartState", {StartState.MSG_KEY_NO_RESTOCK: true})
	else:
		# TODO: Transition to PlaceState instead, once implemented!
		state_machine.transition_to("EndState")

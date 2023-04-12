extends AbstractState
class_name StartState

export var market_path: NodePath
onready var market : Market = get_node(market_path)
onready var money_market: MoneyMarket = get_node(market_path).money_market

const MAX_MONEY_MARKET_CARDS = 4

var card_scene = preload("res://Drawable/Card/MoneyCardDrawable.tscn")


# Override get_class
#
# @visibility: public
# @return: String
func get_class() -> String:
	return "StartState"


# Enter State
# Initialize/reset
#
# @visibility: public
# @param _msg: Dictionary - parameters (ignored)
# @return: void
func enter(_msg := {}) -> void:
	_refill()
	_bind_pressed_events()


# Exit State
#
# @visibility: public
# @return: void
func exit() -> void:
	_unbind_pressed_events()


# Binds the "pressed" event on all money cards on the money market
#
# @visibility: private
# @return: void
func _bind_pressed_events() -> void:
	var pick_state = get_node("../PickState")
	for card_node in money_market.get_children():
		card_node.connect("pressed", self, "_on_money_card_pressed", [card_node])


# Unbinds thre "pressed" event on all money cards on the money market
#
# @visibility: private
# @return: void
func _unbind_pressed_events() -> void:
	for card_node in money_market.get_children():
		card_node.disconnect("pressed", self, "_on_money_card_pressed")


# Handler for the pressed event of Money Market cards
#
# @visibility: private
# @return: void
func _on_money_card_pressed(card_node: MoneyCardDrawable) -> void:
	state_machine.transition_to("PickState", {"card_node": card_node})


# Retrieves the amount of money market cards currently active
#
# TODO: Should probably check for Global.money_stack's size instead
#
# @visibility: private
# @return: void
func _get_active_money_card_count() -> int:
	return money_market.get_child_count()


# Refill the Money Market
#
# @visibility: private
# @return: void
func _refill() -> void:
	var cards_to_refill_count = MoneyMarket.MAX_MONEY_MARKET_CARDS - _get_active_money_card_count()
	for _i in range(cards_to_refill_count):
		var card = Global.stack_money.take_card()
		Global.market_stack_money.add_card(card)
		var card_node = card_scene.instance()
		card_node.card_info = card
		money_market.add_child(card_node)

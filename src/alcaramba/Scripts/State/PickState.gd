extends AbstractState
class_name PickState

const PICK_MAX_VALUE := 5

export var market_path: NodePath
onready var market : Market = get_node(market_path)
onready var money_market: MoneyMarket = get_node(market_path).money_market

var amount_picked := 0

# Override get_class
func get_class() -> String:
	return "PickState"


# Enter State
# Initialize/reset
#
# @visibility: public
# @param _msg: Dictionary - parameters (ignored)
# @return: void
func enter(_msg := {}) -> void:
	amount_picked = 0
	_bind_pressed_events()


# Exit State
func exit():
	for card_node in money_market.get_children():
		card_node.disconnect("pressed", self, "pick_card")


# Binds thre "pressed" event on all money cards on the money market
#
# @visibility: private
# @return: void
func _bind_pressed_events() -> void:
	for card_node in money_market.get_children():
		card_node.connect("pressed", self, "pick_card", [card_node])


# Pick a card. Transition to BuyState if:
# - the total sum of the cards picked this turn is 5
# - The player cannot pick any more cards, because it would exceed 5
#
# @visibility: public
# @param card: MoneyCardDrawable - The card to pick
# @return: void
func pick_card(card_node: MoneyCardDrawable) -> void:
	var card_info: MoneyCard = card_node.card_info
	if !can_pick(card_info):
		return
		
	amount_picked += card_info._value
	card_node.disconnect("pressed", self, "pick_card")
	Global.active_player.money_cards.add_card(card_info)
	money_market.remove_child(card_node)
	
	if !could_pick_more():
		state_machine.transition_to("BuyState")


# Check whether one can pick the money card
#
# @visibility: public
# @param card: MoneyCard - The card to pick
# @return: bool - Whether the card can be picked
func can_pick(card: MoneyCard) -> bool:
	# Can pick any card if there was none picked yet
	if amount_picked == 0:
		return true
		
	# Subsequent picks need to amount to not more than PICK_MAX_VALUE:
	if amount_picked + card._value > PICK_MAX_VALUE:
		return false
		
	return true


# Check whether there are any cards the player could still pick
#
# @visibility: public
# @return: bool - Whether there are still cards that can be picked
func could_pick_more() -> bool:
	# If there is at least one card the player can still pick, return true
	for market_card in Global.market_stack_money._stack:
		if can_pick(market_card):
			return true
	
	return false

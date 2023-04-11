extends AbstractState
class_name PickState

const PICK_MAX_VALUE := 5

var cards_picked: MoneyCardCollection

# Override get_class
func get_class() -> String:
	return "PickState"


func enter(_msg := {}) -> void:
	cards_picked = MoneyCardCollection.new()
	
	
# Pick a card. Transition to BuyState if:
# - the total sum of the cards picked this turn is 5
# - The player cannot pick any more cards, because it would exceed 5
#
# @visibility: public
# @param card: MoneyCard - The card to pick
# @return: void
func pick_card(card: MoneyCard) -> void:
	
	var current_sum = cards_picked.sum_amount()
	
	if !can_pick(card):
		return
		
	cards_picked.add_card(card)
	
#	if cards_picked.sum_amount() >= PICK_MAX_VALUE:
	if !could_pick_more():
		state_machine.transition_to("BuyState")


# Check whether one can pick the money card
#
# @visibility: public
# @param card: MoneyCard - The card to pick
# @return: bool - Whether the card can be picked
func can_pick(card: MoneyCard) -> bool:
	if cards_picked.sum_amount() + card._value > PICK_MAX_VALUE:
		return false
		
	return true


# Check whether there are any cards the player could still pick
#
# @visibility: public
# @return: bool - Whether there are still cards that can be picked
func could_pick_more() -> bool:
	var current_pick_total = cards_picked.sum_amount()
	
	# If there is at least one card the player can still pick, return true
	for market_card in Global.market_stack_money:
		if can_pick(market_card):
			return true
	
	return false

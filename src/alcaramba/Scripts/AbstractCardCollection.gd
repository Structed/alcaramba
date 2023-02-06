extends Object
class_name AbstractCardCollection

var _stack: Array = []

func get_card_count() -> int:
	return _stack.size()

func get_cards() -> Array:
	return _stack

func shuffle():
	_stack.shuffle()

func _take_card():
	return _stack.pop_back()

func get_card_info_by_id(id: int):
	for card in _stack:
		if card._id == id:
			return card
	return null

# Checks whether a `card` exists in the collection
# 
# @param card: AbstractCard
# @returns: bool - Whether the card exists in the Collection
func has_card(card: AbstractCard) -> bool:
	return has_card_by_id(card.get_id())

# Checks whether a card with a given `id` exists in the collection
# 
# @param id: int
# @returns: bool - Whether the card exists in the Collection
func has_card_by_id(id: int) -> bool:
	if get_card_info_by_id(id) == null:
		return false
		
	return true

func get_card_info_by_index(index: int):
	return _stack[index]

func add_card(card : AbstractCard):
	_stack.append(card)

# removes all cards with certain id
func remove_card_by_id(id: int):
	for card in _stack:
		if card._id == id:
			_stack.erase(card)

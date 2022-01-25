extends Object
class_name AbstractCardCollection

var _stack: Array
	
func get_card_count() -> int:
	return _stack.size()
	
func get_cards() -> Array:
	return _stack

func shuffle():
	_stack.shuffle()

func _take_card():
	return _stack.pop_back()
	
func get_card_by_id(id: int):
	for card in _stack:
		if card._id == id:
			return card
	return null
	
func add_card(card):
	_stack.append(card)

# removes all cards with certain id
func remove_card_by_id(id: int):
	for card in _stack:
		if card._id == id:
			_stack.erase(card)



extends Object
class_name AbstractCardCollection

var _stack: Array
	
func get_card_count() -> int:
	return _stack.size()
	
func get_cards() -> Array:
	return _stack

func shuffle():
	_stack.shuffle()

func _draw_card():
	return _stack.pop_back()

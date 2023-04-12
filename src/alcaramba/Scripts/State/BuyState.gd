extends AbstractState
class_name BuyState

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
	if _msg.size() > 0:
		print_debug(_msg["card_node"])
#		pick_card(_msg["card_node"])


# Exit State
#
# @visibility: public
# @return: void
func exit():
	pass

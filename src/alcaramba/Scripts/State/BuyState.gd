extends AbstractState
class_name BuyState

# Override get_class
func get_class() -> String:
	return "BuyState"


# Enter State
# Initialize/reset
#
# @visibility: public
# @param _msg: Dictionary - parameters (ignored)
# @return: void
func enter(_msg := {}) -> void:
	pass


# Exit State
func exit():
	pass

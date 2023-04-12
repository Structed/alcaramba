extends AbstractState
class_name EndState

# Override get_class
#
# @visibility: public
# @return: String
func get_class() -> String:
	return "EndState"


# Enter State
# Initialize/reset
#
# @visibility: public
# @param _msg: Dictionary - parameters (ignored)
# @return: void
func enter(_msg := {}) -> void:
	state_machine.transition_to("StartState")


# Exit State
#
# @visibility: public
# @return: void
func exit():
	pass

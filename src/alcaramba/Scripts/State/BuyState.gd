extends AbstractState
class_name BuyState

export var market_path: NodePath
onready var market : Market = get_node(market_path)
onready var tile_market: TileMarket = get_node(market_path).tile_market
onready var hand: HandDrawable = get_node(market_path).hand


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


# Handler for End Turn Button
#
# @visibility: private
# @return: void
func _on_end_turn_pressed() -> void:
	state_machine.transition_to("EndState")

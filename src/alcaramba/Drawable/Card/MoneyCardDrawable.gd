extends TextureButton
class_name MoneyCardDrawable

# Selected flag
# @visibility: public
var _selected := false setget ,is_selected

# @visibility: public
var card_info: MoneyCard

# @visibility: private
onready var _anim_player := get_node("%AnimationPlayer") as AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	$Value.text = str(card_info._value)
	$Value.self_modulate = Color(0,0,0)
	self_modulate = card_info.get_color()


# Enable the card to be selectable with a mouse click
# Necessary, when the "pressed" signal was previously used for other purposes
# @visibility: public
# @returns: void
func enable_selectable():
	var _error = self.connect("pressed", self, "toggle_select")
	if _error:
		print_debug("Error while connecting signal ")


# Toggle the selected state an play animation based on state
# @visibility: public
# @returns: void
func toggle_select():
	_selected = !_selected
		
	if _selected:
		_anim_player.play("Select")
	else:
		_anim_player.play("Deselect")


# Check whether the card is selected
# @visibility: public
# @returns: bool - Whether the card is selected
func is_selected() -> bool:
	return _selected


# Deselect a card, only if it is selected
func deselect():
	if is_selected():
		toggle_select()

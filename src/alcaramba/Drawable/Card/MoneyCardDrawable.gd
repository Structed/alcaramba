extends TextureButton
class_name MoneyCardDrawable


var _card_info: MoneyCard


# Called when the node enters the scene tree for the first time.
func _ready():
	$Value.text = str(_card_info._value)
	$Value.self_modulate = Color(0,0,0)
	self_modulate = _card_info.get_color()

extends TextureButton


var _card_info: MoneyCard


# Called when the node enters the scene tree for the first time.
func _ready():
	$Value.text = str(_card_info._value)
	$Value.self_modulate = Color(0,0,0)
	self_modulate = _card_info.get_color()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

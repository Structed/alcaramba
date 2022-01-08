extends TextureButton
class_name TileCardDrawable

var _card_info: TileCard


# Called when the node enters the scene tree for the first time.
func _ready():
	update_control()
	
func update_control() -> void:
	if _card_info:
		$Value.text = str(_card_info._value)
		$Value.self_modulate = Color(0,0,0)
		self_modulate = _card_info.get_color()

func set_card_info(card_info: TileCard):
	_card_info = card_info
	update_control()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

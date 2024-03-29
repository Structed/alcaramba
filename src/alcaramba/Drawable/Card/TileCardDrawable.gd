extends TextureButton
class_name TileCardDrawable

var _card_info: TileCard
# Added to be able to select the currency in the TileMarket
export(MoneyCard.Currency) var currency


# Called when the node enters the scene tree for the first time.
func _ready():
	update_control()

func update_control() -> void:
	if _card_info:
		$Value.text = str(_card_info._value)
		$Value.self_modulate = Color(0,0,0)
		self_modulate = _card_info.get_color()
		reset_walls()
		draw_walls()

func set_card_info(card_info: TileCard):
	_card_info = card_info
	update_control()

func draw_walls():
	var walls = _card_info.get_enabled_walls()
	if walls[TileCard.WallSide.WALL_SIDE_TOP]:
		$Panel_WallTop.visible = true
	if walls[TileCard.WallSide.WALL_SIDE_BOTTOM]:
		$Panel_WallBottom.visible = true
	if walls[TileCard.WallSide.WALL_SIDE_LEFT]:
		$Panel_WallLeft.visible = true
	if walls[TileCard.WallSide.WALL_SIDE_RIGHT]:
		$Panel_WallRight.visible = true

func reset_walls():
	$Panel_WallTop.visible = false
	$Panel_WallBottom.visible = false
	$Panel_WallLeft.visible = false
	$Panel_WallRight.visible = false

func select():
	set_scale(Vector2(1.5, 1.5))
	
func deselect():
	set_scale(Vector2(1, 1))

# Resets the drawable
func reset():
	deselect()

# remove card info, set invisible and reset
func clear():
	visible = false
	_card_info = null
	reset()

extends Control

const MAX_MARKET_CARDS = 4

var tile_card_scene = preload("res://Drawable/Card/TileCardDrawable.tscn")

onready var end_turn_button = get_node("%EndTurnButton")
onready var tile_market = get_node("%TileMarket")
onready var money_market = get_node("%MoneyMarket")


# Called when the node enters the scene tree for the first time.
func _ready():
	money_market.connect("money_card_selected", self, "_on_money_card_selected")
	_on_EndTurnButton_pressed()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var can_refill = _check_can_refill_cards()
	if (can_refill):
		end_turn_button.disabled = false
	else:
		end_turn_button.disabled = true


func _check_can_refill_cards() -> bool:
	if money_market.is_missing_cards() || tile_market.is_missing_cards():
		return true
	else:
		return false


func _on_EndTurnButton_pressed():
	tile_market.refill()
	money_market.refill()


func _on_money_card_selected(card_node: MoneyCardDrawable):
	$Hand.add_child(card_node)

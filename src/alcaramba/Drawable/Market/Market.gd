extends Control
class_name Market

const MAX_MARKET_CARDS = 4


var tile_card_scene = preload("res://Drawable/Card/TileCardDrawable.tscn")

onready var end_turn_button = get_node("%EndTurnButton")
onready var tile_market := get_node("%TileMarket") as TileMarket
onready var money_market = get_node("%MoneyMarket") as MoneyMarket
onready var hand := get_node("%Hand") as HandDrawable


# Called when the node enters the scene tree for the first time.
func _ready():
	_on_EndTurnButton_pressed()
	end_turn_button.disabled = true


func _check_can_refill_cards() -> bool:
	if money_market.is_missing_cards() || tile_market.is_missing_cards():
		return true
	else:
		return false


func _on_EndTurnButton_pressed():
	tile_market.refill()

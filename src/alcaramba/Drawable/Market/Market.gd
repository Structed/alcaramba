extends Control

const MAX_MARKET_CARDS = 4

var card_scene = preload("res://Drawable/Card/MoneyCardDrawable.tscn")
var tile_card_scene = preload("res://Drawable/Card/TileCardDrawable.tscn")

onready var end_turn_button = get_node("%EndTurnButton")
onready var tile_market = get_node("%TileMarket")


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.stack_tiles.shuffle()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var can_refill = _check_can_refill_cards()
	if (can_refill):
		end_turn_button.disabled = false
	else:
		end_turn_button.disabled = true


func _get_active_money_card_count() -> int:
	return $MarketsPanel/MoneyMarket/MoneyCards.get_child_count()


func _check_can_refill_cards() -> bool:
	if _get_active_money_card_count() < MAX_MARKET_CARDS || tile_market.cards_can_be_refilled():
		return true
	else:
		return false


func _on_EndTurnButton_pressed():
	tile_market.refill_tiles()

	var cards_to_refill_count = MAX_MARKET_CARDS - _get_active_money_card_count()
	for _i in range(cards_to_refill_count):
		var card = Global.stack_money.take_card()
		var card_node = card_scene.instance()
		card_node._card_info = card
		$MarketsPanel/MoneyMarket/MoneyCards.add_child(card_node)
		card_node.connect("pressed", self, "_on_MoneyCard_pressed", [card_node])


func _on_MoneyCard_pressed(card_node: MoneyCardDrawable):
	card_node.disconnect("pressed", self, "_on_MoneyCard_pressed")
	Global.active_player.money_cards.add_card(card_node._card_info)
	$MarketsPanel/MoneyMarket/MoneyCards.remove_child(card_node)
	$MarketsPanel/Hand/Cards.add_child(card_node)

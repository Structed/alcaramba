extends Control

const MAX_MONEY_MARKET_CARDS = 4

var stack_money: MoneyCardCollection
var card_scene = preload("res://NewCard/NewMoneyCard.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var can_refill = _check_can_refill_cards()
	if (can_refill):
		$Panel/MoneyMarket/RefillCards.disabled = false
	else:
		$Panel/MoneyMarket/RefillCards.disabled = true

func _get_active_card_count() -> int:
	return $Panel/MoneyMarket/MoneyCards.get_child_count()

func _check_can_refill_cards() -> bool:
	if _get_active_card_count() < MAX_MONEY_MARKET_CARDS:
		return true
	else:
		return false


func _on_RefillCards_pressed():
	var card = stack_money.draw_card()
	var cards_to_refill = MAX_MONEY_MARKET_CARDS - _get_active_card_count()
	for i in range(cards_to_refill):
		var card_node = card_scene.instance()
		card_node._card_info = card
		$Panel/MoneyMarket/MoneyCards.add_child(card_node)

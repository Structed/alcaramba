extends Control

const MAX_MONEY_MARKET_CARDS = 4

var stack_money: MoneyCardCollection
var card_scene = preload("res://Drawable/Card/MoneyCardDrawable.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
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
	var cards_to_refill_count = MAX_MONEY_MARKET_CARDS - _get_active_card_count()
	for _i in range(cards_to_refill_count):
		var card = stack_money.draw_card()		
		var card_node = card_scene.instance()
		card_node._card_info = card
		$Panel/MoneyMarket/MoneyCards.add_child(card_node)
		card_node.connect("pressed", self, "_on_MoneyCard_pressed", [card_node])

func _on_MoneyCard_pressed(card_node: TextureButton):
#	card_node.visible = false
#	var card_info = card_node._card_info # TODO: Pass card info to card hand - or re-parent drawable directly?
#	card_node.queue_free()
	$Panel/MoneyMarket/MoneyCards.remove_child(card_node)
	$Panel/Hand/Cards.add_child(card_node)

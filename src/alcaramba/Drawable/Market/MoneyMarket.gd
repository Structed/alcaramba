extends HBoxContainer
class_name MoneyMarket


const MAX_MONEY_MARKET_CARDS = 4

var card_scene = preload("res://Drawable/Card/MoneyCardDrawable.tscn")


func is_missing_cards():
	return _get_active_money_card_count() < MAX_MONEY_MARKET_CARDS


func _get_active_money_card_count() -> int:
	return get_child_count()


func refill():
	var cards_to_refill_count = MAX_MONEY_MARKET_CARDS - _get_active_money_card_count()
	for _i in range(cards_to_refill_count):
		var card = Global.stack_money.take_card()
		Global.market_stack_money.add_card(card)
		var card_node = card_scene.instance()
		card_node.card_info = card
		add_child(card_node)

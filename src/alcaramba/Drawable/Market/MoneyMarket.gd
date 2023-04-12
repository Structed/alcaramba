extends HBoxContainer
class_name MoneyMarket


const MAX_MONEY_MARKET_CARDS = 4


func is_missing_cards() -> bool:
	return _get_active_money_card_count() < MAX_MONEY_MARKET_CARDS


func _get_active_money_card_count() -> int:
	return get_child_count()

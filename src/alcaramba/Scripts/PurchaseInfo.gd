extends Reference
class_name PurchaseInfo

var tile : TileCard
var selected_money_cards := MoneyCardCollection.new()

# @param drawables: Array[MoneyCardDrawable] - Teh cards selected to pay for the Tile
func set_selected_money_cards(drawables: Array):
	for card in drawables:
		selected_money_cards.add_card((card as MoneyCardDrawable).card_info)

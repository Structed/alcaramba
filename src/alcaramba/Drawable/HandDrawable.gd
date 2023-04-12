extends Control
class_name HandDrawable


var card_scene = preload("res://Drawable/Card/MoneyCardDrawable.tscn")



# Remove all hand cards and re-draw them
# from the global hand cards of the active player
# @visibility: private
func redraw():
	for child in get_children():
		remove_child(child)
	
	for card in Global.active_player.money_cards.get_cards():
		var card_drawable = card_scene.instance()
		card_drawable.card_info = (card as MoneyCard)
		_add_card_node(card_drawable)


# Add a card node to the hand and enable it to be selectable
# @visibility: private
# @param card_drawable: MoneyCardDrawable - The card drawable to add to the Hand
func _add_card_node(card_drawable: MoneyCardDrawable):
#	card_drawable.enable_selectable()
	add_child(card_drawable)


# Returns all cards which are of a given currency and are selected
#
# @visibility: public
# @param currency: MoneyCard.Currency
# @returns: MoneyCardCollection - The selected cards of given currency
func get_selected_cards_by_currency(currency: int) -> Array:
	var selected = MoneyCardCollection.new()
	for child in get_children():
		var money_card := child as MoneyCardDrawable
		if money_card.is_selected():
			var card_info := money_card.card_info
			if card_info.get_currency() == currency:
				selected.add_card(card_info)

	return selected


# Deselect all cards
func deselect_all():
	for card in get_children():
		(card as MoneyCardDrawable).deselect()

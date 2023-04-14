extends Control
class_name Market

const MAX_MARKET_CARDS = 4

# Receives a `TileCardDrawable`
signal tile_card_selected

var tile_card_scene = preload("res://Drawable/Card/TileCardDrawable.tscn")

onready var end_turn_button = get_node("%EndTurnButton")
onready var tile_market := get_node("%TileMarket") as TileMarket
onready var money_market = get_node("%MoneyMarket") as MoneyMarket
onready var hand := get_node("%Hand") as HandDrawable


# Called when the node enters the scene tree for the first time.
func _ready():
	_on_EndTurnButton_pressed()
	end_turn_button.disabled = true

	var _ignore
	_ignore = tile_market.card1.connect("pressed", self, "_on_TileCard_pressed", [tile_market.card1])
	_ignore = tile_market.card2.connect("pressed", self, "_on_TileCard_pressed", [tile_market.card2])
	_ignore = tile_market.card3.connect("pressed", self, "_on_TileCard_pressed", [tile_market.card3])
	_ignore = tile_market.card4.connect("pressed", self, "_on_TileCard_pressed", [tile_market.card4])


func _check_can_refill_cards() -> bool:
	if money_market.is_missing_cards() || tile_market.is_missing_cards():
		return true
	else:
		return false

func _on_TileCard_pressed(card_node: TileCardDrawable):
	# Determine the currency & amount of money needed to buy the selected Tile
	var amount = card_node._card_info._value
	var currency = card_node.currency # MoneyCard.Currency

	# Get all selected money cards in Hand which match the selected Tile's currency
	var selected = hand.get_selected_cards_by_currency(currency)
	
	var purchase_info = PurchaseInfo.new()
	purchase_info.selected_money_cards = selected
	purchase_info.tile = card_node._card_info

	# If there are enough cards selected to fulfil the required amount,
	# Allow proceeding (place tile in town or spare yard)
	if selected.sum_amount() >= amount:
		Global.active_player.purchase_info = purchase_info
		emit_signal("tile_card_selected", card_node)

func _on_EndTurnButton_pressed():
	tile_market.refill()

extends Node

var money: CardStack
var tiles: CardStack

# Called when the node enters the scene tree for the first time.
func _ready():
	money = CardStack.new(MoneyCard.CardTypes.MONEY)
	print_debug("Crated a stack of %d money cards" % money.get_card_count())
	
	tiles = CardStack.new(MoneyCard.CardTypes.TILE)
	print_debug("Crated a stack of %d tile cards" % tiles.get_card_count())
	var cards = tiles.get_cards()
	for card in cards:
		print_debug("Value: %d; Type: %d; Walls: %d" % [card._value, card._tile_type, card._walls])
		card.print_enabled_walls()

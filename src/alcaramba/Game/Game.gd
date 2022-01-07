extends Node

var money: AbstractCardCollection
var tiles: AbstractCardCollection

# Called when the node enters the scene tree for the first time.
func _ready():
	money = AbstractCardCollection.new(MoneyCard.CardTypes.MONEY)
	$Market.stack_money = money
	
#	$Hand.money_stack = money
#	print_debug("Crated a stack of %d money cards" % money.get_card_count())
#
#	tiles = AbstractCardCollection.new(MoneyCard.CardTypes.TILE)
#	print_debug("Crated a stack of %d tile cards" % tiles.get_card_count())
#	var cards = tiles.get_cards()
#	#for card in cards:
#		#print_debug("Value: %d; Type: %d; Walls: %d" % [card._value, card._tile_type, card._walls])
#		#card.print_enabled_walls()

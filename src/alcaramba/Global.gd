extends Node

var player: Player
var stack_money: MoneyCardCollection
var stack_tiles: TileCardCollection

func _init():
	player = Player.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	stack_money = MoneyCardCollection.new()
	print_debug("Crated a stack of %d money cards" % stack_money.get_card_count())

	stack_tiles = TileCardCollection.new()
	print_debug("Crated a stack of %d tile cards" % stack_tiles.get_card_count())
#	var cards = stack_tiles.get_cards()
#	for card in cards:
#		print_debug("Value: %d; Type: %d; Walls: %d" % [card._value, card._tile_type, card._walls])
#		card.print_enabled_walls()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

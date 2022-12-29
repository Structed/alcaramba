extends Node

var players: Array = []
var active_player: Player
var stack_money: MoneyCardCollection = MoneyCardCollection.new()
var stack_tiles: TileCardCollection = TileCardCollection.new()
var market_stack_money: MoneyCardCollection = MoneyCardCollection.new()
var market_stack_tiles: TileCardCollection = TileCardCollection.new()

func _init():
	active_player = Player.new(0, "Player 1")
	players.append(active_player)

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

	stack_money.initialize_for_game_start()
	print_debug("Crated a stack of %d money cards" % stack_money.get_card_count())

	stack_tiles.initialize_for_game_start()
	stack_tiles.shuffle()
	print_debug("Crated a stack of %d tile cards" % stack_tiles.get_card_count())
#	var cards = stack_tiles.get_cards()
#	for card in cards:
#		print_debug("Value: %d; Type: %d; Walls: %d" % [card._value, card._tile_type, card._walls])
#		card.print_enabled_walls()



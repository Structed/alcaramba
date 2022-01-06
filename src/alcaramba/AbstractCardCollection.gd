extends Object
class_name AbstractCardCollection

var _stack: Array


func _init(cardType):
	if cardType == MoneyCard.CardTypes.MONEY:
		init_money()
	else:
		init_tiles()
		
	shuffle()

func init_money():
	_stack = []
	var id = 0
	for currencyType in MoneyCard.Currency.size():
		for value in range(MoneyCard.MIN_VALUE, MoneyCard.MAX_VALUE+1):
			for _amount in range(MoneyCard.CARDS_PER_CURRENCY):
				var card = MoneyCard.new()
				card._id = id
				card._type = AbstractCard.CardTypes.MONEY
				card._value = value
				card._currency = currencyType
				
				_stack.append(card)
				id += 1

func init_tiles():
	_stack = []
	var id = 0
	
	# Blue
	_stack.append(TileCard.new(0, 2, TileCard.TileType.BLUE, TileCard.WALL_SIDE_LEFT | TileCard.WALL_SIDE_TOP | TileCard.WALL_SIDE_RIGHT))
	_stack.append(TileCard.new(1, 3, TileCard.TileType.BLUE, TileCard.WALL_SIDE_LEFT | TileCard.WALL_SIDE_BOTTOM))
	_stack.append(TileCard.new(2, 4, TileCard.TileType.BLUE, TileCard.WALL_SIDE_RIGHT | TileCard.WALL_SIDE_BOTTOM))
	_stack.append(TileCard.new(3, 5, TileCard.TileType.BLUE, TileCard.WALL_SIDE_LEFT | TileCard.WALL_SIDE_TOP))
	_stack.append(TileCard.new(4, 6, TileCard.TileType.BLUE, TileCard.WALL_SIDE_TOP))
	_stack.append(TileCard.new(5, 7, TileCard.TileType.BLUE, TileCard.WALL_SIDE_RIGHT))
	_stack.append(TileCard.new(6, 7, TileCard.TileType.BLUE, TileCard.WALL_SIDE_NONE))
	
	# Red
	_stack.append(TileCard.new(7, 3, TileCard.TileType.RED, TileCard.WALL_SIDE_LEFT | TileCard.WALL_SIDE_BOTTOM | TileCard.WALL_SIDE_RIGHT))
	_stack.append(TileCard.new(8, 4, TileCard.TileType.RED, TileCard.WALL_SIDE_TOP | TileCard.WALL_SIDE_RIGHT))
	_stack.append(TileCard.new(9, 5, TileCard.TileType.RED, TileCard.WALL_SIDE_LEFT | TileCard.WALL_SIDE_BOTTOM))
	_stack.append(TileCard.new(10, 6, TileCard.TileType.RED, TileCard.WALL_SIDE_BOTTOM | TileCard.WALL_SIDE_RIGHT))
	_stack.append(TileCard.new(11, 7, TileCard.TileType.RED, TileCard.WALL_SIDE_LEFT))
	_stack.append(TileCard.new(12, 8, TileCard.TileType.RED, TileCard.WALL_SIDE_BOTTOM))
	_stack.append(TileCard.new(13, 9, TileCard.TileType.RED, TileCard.WALL_SIDE_NONE))
	
	# Brown
	_stack.append(TileCard.new(14, 4, TileCard.TileType.BROWN, TileCard.WALL_SIDE_TOP | TileCard.WALL_SIDE_RIGHT | TileCard.WALL_SIDE_BOTTOM))
	_stack.append(TileCard.new(15, 5, TileCard.TileType.BROWN, TileCard.WALL_SIDE_LEFT | TileCard.WALL_SIDE_TOP))
	_stack.append(TileCard.new(16, 6, TileCard.TileType.BROWN, TileCard.WALL_SIDE_LEFT | TileCard.WALL_SIDE_BOTTOM))
	_stack.append(TileCard.new(17, 6, TileCard.TileType.BROWN, TileCard.WALL_SIDE_TOP | TileCard.WALL_SIDE_RIGHT))
	_stack.append(TileCard.new(18, 7, TileCard.TileType.BROWN, TileCard.WALL_SIDE_BOTTOM | TileCard.WALL_SIDE_RIGHT))
	_stack.append(TileCard.new(19, 8, TileCard.TileType.BROWN, TileCard.WALL_SIDE_RIGHT))
	_stack.append(TileCard.new(20, 8, TileCard.TileType.BROWN, TileCard.WALL_SIDE_TOP))
	_stack.append(TileCard.new(21, 9, TileCard.TileType.BROWN, TileCard.WALL_SIDE_NONE))
	_stack.append(TileCard.new(22, 10, TileCard.TileType.BROWN, TileCard.WALL_SIDE_NONE))
	
	# White
	_stack.append(TileCard.new(23, 5, TileCard.TileType.WHITE, TileCard.WALL_SIDE_TOP | TileCard.WALL_SIDE_BOTTOM | TileCard.WALL_SIDE_LEFT))
	_stack.append(TileCard.new(24, 6, TileCard.TileType.WHITE, TileCard.WALL_SIDE_RIGHT | TileCard.WALL_SIDE_BOTTOM))
	_stack.append(TileCard.new(25, 7, TileCard.TileType.WHITE, TileCard.WALL_SIDE_BOTTOM | TileCard.WALL_SIDE_LEFT))
	_stack.append(TileCard.new(26, 7, TileCard.TileType.WHITE, TileCard.WALL_SIDE_TOP | TileCard.WALL_SIDE_RIGHT))
	_stack.append(TileCard.new(27, 8, TileCard.TileType.WHITE, TileCard.WALL_SIDE_TOP | TileCard.WALL_SIDE_LEFT))
	_stack.append(TileCard.new(28, 9, TileCard.TileType.WHITE, TileCard.WALL_SIDE_LEFT))
	_stack.append(TileCard.new(29, 9, TileCard.TileType.WHITE, TileCard.WALL_SIDE_BOTTOM))
	_stack.append(TileCard.new(30, 10, TileCard.TileType.WHITE, TileCard.WALL_SIDE_NONE))
	_stack.append(TileCard.new(31, 11, TileCard.TileType.WHITE, TileCard.WALL_SIDE_NONE))
	
	# Green
	_stack.append(TileCard.new(32, 6, TileCard.TileType.GREEN, TileCard.WALL_SIDE_RIGHT | TileCard.WALL_SIDE_BOTTOM | TileCard.WALL_SIDE_LEFT))
	_stack.append(TileCard.new(33, 7, TileCard.TileType.GREEN, TileCard.WALL_SIDE_TOP | TileCard.WALL_SIDE_BOTTOM | TileCard.WALL_SIDE_LEFT))
	_stack.append(TileCard.new(34, 8, TileCard.TileType.GREEN, TileCard.WALL_SIDE_TOP | TileCard.WALL_SIDE_RIGHT))
	_stack.append(TileCard.new(35, 8, TileCard.TileType.GREEN, TileCard.WALL_SIDE_TOP | TileCard.WALL_SIDE_LEFT))
	_stack.append(TileCard.new(36, 8, TileCard.TileType.GREEN, TileCard.WALL_SIDE_BOTTOM | TileCard.WALL_SIDE_LEFT))
	_stack.append(TileCard.new(37, 9, TileCard.TileType.GREEN, TileCard.WALL_SIDE_RIGHT))
	_stack.append(TileCard.new(38, 10, TileCard.TileType.GREEN, TileCard.WALL_SIDE_TOP))
	_stack.append(TileCard.new(39, 10, TileCard.TileType.GREEN, TileCard.WALL_SIDE_LEFT))
	_stack.append(TileCard.new(40, 10, TileCard.TileType.GREEN, TileCard.WALL_SIDE_NONE))
	_stack.append(TileCard.new(41, 11, TileCard.TileType.GREEN, TileCard.WALL_SIDE_NONE))
	_stack.append(TileCard.new(42, 12, TileCard.TileType.GREEN, TileCard.WALL_SIDE_BOTTOM))
		
	# Violet
	_stack.append(TileCard.new(43, 7, TileCard.TileType.VIOLET, TileCard.WALL_SIDE_TOP | TileCard.WALL_SIDE_RIGHT | TileCard.WALL_SIDE_LEFT))
	_stack.append(TileCard.new(44, 8, TileCard.TileType.VIOLET, TileCard.WALL_SIDE_TOP | TileCard.WALL_SIDE_RIGHT | TileCard.WALL_SIDE_BOTTOM))
	_stack.append(TileCard.new(45, 9, TileCard.TileType.VIOLET, TileCard.WALL_SIDE_TOP | TileCard.WALL_SIDE_LEFT))
	_stack.append(TileCard.new(46, 9, TileCard.TileType.VIOLET, TileCard.WALL_SIDE_RIGHT | TileCard.WALL_SIDE_BOTTOM))
	_stack.append(TileCard.new(47, 9, TileCard.TileType.VIOLET, TileCard.WALL_SIDE_TOP | TileCard.WALL_SIDE_RIGHT))
	_stack.append(TileCard.new(48, 10, TileCard.TileType.VIOLET, TileCard.WALL_SIDE_LEFT))
	_stack.append(TileCard.new(49, 11, TileCard.TileType.VIOLET, TileCard.WALL_SIDE_BOTTOM))
	_stack.append(TileCard.new(50, 11, TileCard.TileType.VIOLET, TileCard.WALL_SIDE_TOP))
	_stack.append(TileCard.new(51, 11, TileCard.TileType.VIOLET, TileCard.WALL_SIDE_NONE))
	_stack.append(TileCard.new(52, 12, TileCard.TileType.VIOLET, TileCard.WALL_SIDE_NONE))
	_stack.append(TileCard.new(53, 13, TileCard.TileType.VIOLET, TileCard.WALL_SIDE_RIGHT))
	
func get_card_count() -> int:
	return _stack.size()
	
func get_cards() -> Array:
	return _stack

func shuffle():
	_stack.shuffle()

func draw_money_card() -> MoneyCard:
	return draw_card()
	
func draw_tile_card() -> TileCard:
	return draw_card()

func draw_card():
	return _stack.pop_back()

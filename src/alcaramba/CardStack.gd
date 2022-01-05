extends Object
class_name CardStack

var _stack: Array


func _init(cardType):
	if cardType == MoneyCard.CardTypes.MONEY:
		initMoney()
	else:
		initTiles()

func initMoney():
	_stack = []
	var id = 0
	for currencyType in MoneyCard.Currency.size():
		for value in range(MoneyCard.MIN_VALUE, MoneyCard.MAX_VALUE+1):
			for _amount in range(MoneyCard.CARDS_PER_CURRENCY):
				var card = MoneyCard.new()
				card.id = id
				card.type = AbstractCard.CardTypes.MONEY
				card.value = value
				card.currency = currencyType
				
				_stack.append(card)
				id += 1

func initTiles():
	pass
	
func get_card_count() -> int:
	return _stack.size()

func shuffle():
	_stack.shuffle()

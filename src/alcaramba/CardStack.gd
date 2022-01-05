extends Object
class_name CardStack



func _init(cardType):
	if cardType == MoneyCard.CardTypes.MONEY:
		initMoney()
	else:
		initTiles()

func initMoney():
	stack = []
	var id = 0
	for currencyType in MoneyCard.Currency.size():
		for value in range(MoneyCard.MIN_VALUE, MoneyCard.MAX_VALUE+1):
			for _amount in range(MoneyCard.CARDS_PER_CURRENCY):
				var card = MoneyCard.new()
				card.id = id
				card.type = AbstractCard.CardTypes.MONEY
				card.value = value
				card.currency = currencyType
				
				stack.append(card)
				id += 1

func initTiles():
	pass

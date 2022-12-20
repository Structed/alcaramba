extends AbstractCardCollection
class_name MoneyCardCollection


func initialize_for_game_start():
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
	shuffle()

func take_card() -> MoneyCard:
	return _take_card()

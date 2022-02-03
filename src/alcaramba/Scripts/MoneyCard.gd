extends AbstractCard
class_name MoneyCard

const MIN_VALUE = 1
const MAX_VALUE = 9
const CARDS_PER_CURRENCY = 3

enum Currency {BLUE, YELLOW, GREEN, ORANGE}

# Of type enum Currency
var _currency: int

func get_color() -> Color:
	var color: Color
	match _currency:
		Currency.BLUE:
			color = Colors.BLUE
		Currency.YELLOW:
			color = Colors.YELLOW
		Currency.GREEN:
			color = Colors.GREEN
		Currency.ORANGE:
			color = Colors.ORANGE
		_:
			color = Colors.DEFAULT
	
	return color

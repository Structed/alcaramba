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
			color = Color(0.14902, 0.360784, 1)
		Currency.YELLOW:
			color = Color(1, 0.890196, 0.278431)
		Currency.GREEN:
			color = Color(0.14902, 0.498039, 0)
		Currency.ORANGE:
			color = Color(1, 0.415686, 0)
		_:
			color = Color(1, 1, 1)
	
	return color

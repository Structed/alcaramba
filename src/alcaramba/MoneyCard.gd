extends AbstractCard
class_name MoneyCard

const MIN_VALUE = 1
const MAX_VALUE = 9
const CARDS_PER_CURRENCY = 3

enum Currency {BLUE, YELLOW, GREEN, ORANGE}


var currency: int

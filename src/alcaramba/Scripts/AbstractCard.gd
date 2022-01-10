extends Object
class_name AbstractCard

enum CardTypes {MONEY, TILE}

var _id: int
var _value: int
var _type: int

func get_id()->int:
	return _id
	
func get_value()->int:
	return _value

extends Object
class_name Player


var index: int
var name: String
var money_cards : MoneyCardCollection = MoneyCardCollection.new() # player hand money
var tile_cards_yard: TileCardCollection = TileCardCollection.new()

func _init(player_index : int, player_name : String):
	self.index = player_index
	self.name = player_name

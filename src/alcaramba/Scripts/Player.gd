# This is a an "idea" object - consider this to be an idea of how a player could look like

extends Object
class_name Player


var player_index: int
var name: String
#var alcaramba_layout#: AlcarambaLayout
var money_cards : MoneyCardCollection = MoneyCardCollection.new()

func _init(index : int, name : String):
	self.player_index = index
	self.name = name

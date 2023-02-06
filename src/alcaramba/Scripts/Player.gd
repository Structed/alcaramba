extends Object
class_name Player

var index: int
var name: String
var money_cards : MoneyCardCollection = MoneyCardCollection.new() # player hand money
var tile_cards_yard: TileCardCollection = TileCardCollection.new()
var town_tiles = {}

signal tile_placed

func _init(player_index : int, player_name : String):
	self.index = player_index
	self.name = player_name

func add_town_tile(tile: TileCard, position: Vector2):
	town_tiles[position] = tile._id
	emit_signal("tile_placed")
	#_deselect_tile()
	print_debug(var2str(town_tiles))

func remove_town_tile(position: Vector2):
	town_tiles.erase(position)

extends Object
class_name Player


var index: int
var name: String
var money_cards : MoneyCardCollection = MoneyCardCollection.new()
var tile_cards_yard: TileCardCollection = TileCardCollection.new()
var town_tiles = {}

func _init(player_index : int, player_name : String):
	self.index = player_index
	self.name = player_name

func add_town_tile(tile: TileCard, position: Vector2):
	var x: int = position.x
	var y: int = position.y
	if not town_tiles.has(x):
		town_tiles[x] = {}
	
	town_tiles[x][y] = tile._id
	print_debug(var2str(town_tiles))

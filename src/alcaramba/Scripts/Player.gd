extends Object
class_name Player

# Receives a `TileCard` as parameter
signal added_tile_to_spare_yard
signal tile_placed


var index: int
var name: String
var money_cards : MoneyCardCollection = MoneyCardCollection.new() # player hand money
var tile_cards_yard: TileCardCollection = TileCardCollection.new()
var town_tiles = {}

func _init(player_index : int, player_name : String):
	self.index = player_index
	self.name = player_name

func add_town_tile(tile: TileCard, position: Vector2):
	town_tiles[position] = tile._id
	emit_signal("tile_placed")
	print_debug(var2str(town_tiles))

func remove_town_tile(position: Vector2):
	town_tiles.erase(position)


# Transfers a Tile from Spare Yard to Town
#
# @visibility: public
# @param tile: TileCard - The Tile to move
# @param position: Vector2 - The Town position of the tile
# @param int: Returns `-1` in case of an error. `0` otherwise.
func transfer_tile_spare_to_town(tile: TileCard, position: Vector2) -> int:
	# Nothing to do if the card does nto exist in the yard
	if tile_cards_yard.has_card(tile) == false:
		return 0

	if town_tiles.has(position.x) && town_tiles[position.x].has(position.y):

		var check_tile = town_tiles[position.x][position.y]
		if check_tile is int:
			push_error("There is already a tile at position %d|%d" % [position.x, position.y])
			return -1

	tile_cards_yard.remove_card_by_id(tile.get_id())
	add_town_tile(tile, position)
	return 0

# Add a Tile to the Spare Yard
#
# @param tile: TileCard - The TileCard to add to the Spare Yard
# @return: void
func add_tile_to_spare_yard(tile: TileCard):
	if tile == null:
		push_error("Tile passed to spare yard cannot be null!")

	tile_cards_yard.add_card(tile)
	emit_signal("added_tile_to_spare_yard", tile)

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
var purchase_info : PurchaseInfo

func _init(player_index : int, player_name : String):
	self.index = player_index
	self.name = player_name

func add_town_tile(tile: TileCard, position: Vector2):
	town_tiles[position] = tile._id
	emit_signal("tile_placed", tile)
	print_debug(var2str(town_tiles))

func remove_town_tile(position: Vector2):
	town_tiles.erase(position)


# Transfers a Tile from Spare Yard to Town
#
# @visibility: public
# @param tile: TileCard - The Tile to move
# @return: void
func remove_tile_from_spare_yard(tile: TileCard):
	# Nothing to do if the card does not exist in the yard
	if tile_cards_yard.has_card(tile) == false:
		return

	var removed = tile_cards_yard.remove_card_by_id(tile.get_id())
	
	if removed != 1:
		push_error("Exactly 1 card of it %d should have been removed from spare yard!" % [tile.get_id() as int])


# Add a Tile to the Spare Yard
#
# @param tile: TileCard - The TileCard to add to the Spare Yard
# @return: void
func add_tile_to_spare_yard(tile: TileCard):
	if tile == null:
		push_error("Tile passed to spare yard cannot be null!")

	tile_cards_yard.add_card(tile)
	emit_signal("added_tile_to_spare_yard", tile)

# Purchase a tile using the PurchaseInfo on the Player
func purchase_tile():
	if purchase_info == null:
		return
		
	for money in purchase_info.selected_money_cards.get_cards():
		var id = money.get_id()
		var removed_count = money_cards.remove_card_by_id(id)
		if removed_count != 1:
			push_error("Only one card with ID %d should have been removed, but %d were removed!" % [id, removed_count])
	
	# Reset after purchasing, so it doesn't get re-purchased
	purchase_info = null

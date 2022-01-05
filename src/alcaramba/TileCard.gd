extends AbstractCard
class_name TileCard

# 7 Blue/Red
# 9 Brown/White
# 11 Green/Violet

enum TileType {BLUE,RED,BROWN,WHITE,GREEN,VIOLET}

const WALL_SIDE_NONE = 0
const WALL_SIDE_TOP = 1
const WALL_SIDE_RIGHT = 1 << 1
const WALL_SIDE_BOTTOM = 1 << 2
const WALL_SIDE_LEFT = 1 << 3


const WallSide = {
	WALL_SIDE_TOP = "TOP",
	WALL_SIDE_RIGHT = "RIGHT",
	WALL_SIDE_BOTTOM = "BOTTOM",
	WALL_SIDE_LEFT = "LEFT"
}

# 54 cards total
const TOTAL_CARDS = 54
const amounts = {
	TileType.BLUE: 7,
	TileType.RED: 7,
	TileType.BROWN: 9,
	TileType.WHITE: 9,
	TileType.GREEN: 11,
	TileType.VIOLET: 11
}

# One of TileType enum
var _tile_type: int

# Bitmask of WallSide enum
var _walls: int

func _init(id, value, tile_type, walls):
	# AbstractCard props
	_id = id
	_type = AbstractCard.CardTypes.TILE
	_value = value
	
	# Tile Card props
	_tile_type = tile_type
	_walls |= walls

# Set whether a specific side of the tile has a wall
func set_wall(wall_side: int):
	_walls = _walls | wall_side

# Determine whether a specific side of the tile has a wall
func get_wall(wall_side: int):
	return _walls & wall_side
	
func get_enabled_walls():
	var enabled_walls = {"TOP": false, "RIGHT": false, "BOTTOM": false, "LEFT": false}
	enabled_walls["TOP"] = is_bit_enabled(0)
	enabled_walls["RIGHT"] = is_bit_enabled(1)
	enabled_walls["BOTTOM"] = is_bit_enabled(2)
	enabled_walls["LEFT"] = is_bit_enabled(3)
	return enabled_walls
	
func print_enabled_walls():
	var walls = get_enabled_walls()
	for wall_key in walls:
		print("%s: %s" % [wall_key, walls[wall_key]])

func is_bit_enabled(index):
	return _walls & (1 << index) != 0

func enable_bit(_walls, index):
	return _walls | (1 << index)

func disable_bit(_walls, index):
	return _walls & ~(1 << index)

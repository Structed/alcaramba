extends AbstractCard
class_name TileCard



enum TileType {BLUE,RED,BROWN,WHITE,GREEN,VIOLET}

const amounts = {
	TileType.BLUE: 7,
	TileType.RED: 7,
	TileType.BROWN: 9,
	TileType.WHITE: 9,
	TileType.GREEN: 11,
	TileType.VIOLET: 11
}

var tileType: int

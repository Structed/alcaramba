extends TextureRect


const MAX_TILE_MARKET_CARDS = 4

var tile_card_scene = preload("res://Drawable/Card/TileCardDrawable.tscn")

onready var card1 = get_node("%Card1")
onready var card2 = get_node("%Card2")
onready var card3 = get_node("%Card3")
onready var card4 = get_node("%Card4")

# Called when the node enters the scene tree for the first time.
func _ready():
	var _ignore
	_ignore = card1.connect("pressed", self, "_on_TileCard_pressed", [card1])
	_ignore = card2.connect("pressed", self, "_on_TileCard_pressed", [card2])
	_ignore = card3.connect("pressed", self, "_on_TileCard_pressed", [card3])
	_ignore = card4.connect("pressed", self, "_on_TileCard_pressed", [card4])


func get_empty_tile_slot_count() -> int:
	var empty_slots = 0
	empty_slots = empty_slots + 1 if card1._card_info == null else empty_slots
	empty_slots = empty_slots + 1 if card2._card_info == null else empty_slots
	empty_slots = empty_slots + 1 if card3._card_info == null else empty_slots
	empty_slots = empty_slots + 1 if card4._card_info == null else empty_slots

	return empty_slots


func cards_can_be_refilled():
	var empty_tile_slot_count = get_empty_tile_slot_count()
	return empty_tile_slot_count > 0 && empty_tile_slot_count <= MAX_TILE_MARKET_CARDS


func refill():
	_draw_tile(card1)
	_draw_tile(card2)
	_draw_tile(card3)
	_draw_tile(card4)


func _draw_tile(node: TileCardDrawable):
	if node._card_info == null:
		var card_info = Global.stack_tiles.take_card()
		node.set_card_info(card_info)
		node.visible = true


func _on_TileCard_pressed(card_node: TileCardDrawable):
	Global.active_player.tile_cards_yard.add_card(card_node._card_info)
	card_node._card_info = null
	card_node.visible = false

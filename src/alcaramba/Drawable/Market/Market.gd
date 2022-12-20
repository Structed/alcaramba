extends Control

const MAX_MARKET_CARDS = 4

var card_scene = preload("res://Drawable/Card/MoneyCardDrawable.tscn")
var tile_card_scene = preload("res://Drawable/Card/TileCardDrawable.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.stack_tiles.shuffle()
	$MarketsPanel/TileMarket/Card1.connect("pressed", self, "_on_TileCard_pressed", [$MarketsPanel/TileMarket/Card1])
	$MarketsPanel/TileMarket/Card2.connect("pressed", self, "_on_TileCard_pressed", [$MarketsPanel/TileMarket/Card2])
	$MarketsPanel/TileMarket/Card3.connect("pressed", self, "_on_TileCard_pressed", [$MarketsPanel/TileMarket/Card3])
	$MarketsPanel/TileMarket/Card4.connect("pressed", self, "_on_TileCard_pressed", [$MarketsPanel/TileMarket/Card4])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var can_refill = _check_can_refill_cards()
	if (can_refill):
		$MarketsPanel/MoneyMarket/RefillCards.disabled = false
	else:
		$MarketsPanel/MoneyMarket/RefillCards.disabled = true

func _get_active_money_card_count() -> int:
	return $MarketsPanel/MoneyMarket/MoneyCards.get_child_count()
	
func _get_empty_tile_slot_count() -> int:
	var empty_slots = 0 
	empty_slots = empty_slots + 1 if $MarketsPanel/TileMarket/Card1._card_info == null else empty_slots
	empty_slots = empty_slots + 1 if $MarketsPanel/TileMarket/Card2._card_info == null else empty_slots
	empty_slots = empty_slots + 1 if $MarketsPanel/TileMarket/Card3._card_info == null else empty_slots
	empty_slots = empty_slots + 1 if $MarketsPanel/TileMarket/Card4._card_info == null else empty_slots
	
	return empty_slots

func _check_can_refill_cards() -> bool:
	var empty_tile_slot = _get_empty_tile_slot_count()
	if _get_active_money_card_count() < MAX_MARKET_CARDS || (empty_tile_slot > 0 && empty_tile_slot <= MAX_MARKET_CARDS):
		return true
	else:
		return false

func _on_TileCard_pressed(card_node: TextureButton):
	#card_node.disconnect("pressed", self, "on_TileCard_pressed")
	(card_node as TileCardDrawable)._card_info = null
	card_node.visible = false

func _refill_tiles():
	_draw_tile($MarketsPanel/TileMarket/Card1)
	_draw_tile($MarketsPanel/TileMarket/Card2)
	_draw_tile($MarketsPanel/TileMarket/Card3)
	_draw_tile($MarketsPanel/TileMarket/Card4)
		
func _draw_tile(node: TileCardDrawable):
	if node._card_info == null:
		var card_info = Global.stack_tiles.take_card()
		node.set_card_info(card_info)
		node.visible = true

func _on_RefillCards_pressed():
	_refill_tiles()
	
	var cards_to_refill_count = MAX_MARKET_CARDS - _get_active_money_card_count()
	for _i in range(cards_to_refill_count):
		var card = Global.stack_money.take_card()
		var card_node = card_scene.instance()
		card_node._card_info = card
		$MarketsPanel/MoneyMarket/MoneyCards.add_child(card_node)
		card_node.connect("pressed", self, "_on_MoneyCard_pressed", [card_node])

func _on_MoneyCard_pressed(card_node: TextureButton):
	card_node.disconnect("pressed", self, "_on_MoneyCard_pressed")
	$MarketsPanel/MoneyMarket/MoneyCards.remove_child(card_node)
	$MarketsPanel/Hand/Cards.add_child(card_node)

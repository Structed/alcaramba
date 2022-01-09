extends Control

const MAX_MARKET_CARDS = 4

var card_scene = preload("res://Drawable/Card/MoneyCardDrawable.tscn")
var tile_card_scene = preload("res://Drawable/Card/TileCardDrawable.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel/TileMarket/Card1.connect("pressed", self, "_on_TileCard_pressed", [$Panel/TileMarket/Card1])
	$Panel/TileMarket/Card2.connect("pressed", self, "_on_TileCard_pressed", [$Panel/TileMarket/Card2])
	$Panel/TileMarket/Card3.connect("pressed", self, "_on_TileCard_pressed", [$Panel/TileMarket/Card3])
	$Panel/TileMarket/Card4.connect("pressed", self, "_on_TileCard_pressed", [$Panel/TileMarket/Card4])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var can_refill = _check_can_refill_cards()
	if (can_refill):
		$Panel/MoneyMarket/RefillCards.disabled = false
	else:
		$Panel/MoneyMarket/RefillCards.disabled = true

func _get_active_money_card_count() -> int:
	return $Panel/MoneyMarket/MoneyCards.get_child_count()
	
func _get_active_tile_card_count() -> int:
	var elegible = 0 
	elegible = elegible + 1 if $Panel/TileMarket/Card1._card_info == null else elegible
	elegible = elegible + 1 if $Panel/TileMarket/Card2._card_info == null else elegible
	elegible = elegible + 1 if $Panel/TileMarket/Card3._card_info == null else elegible
	elegible = elegible + 1 if $Panel/TileMarket/Card4._card_info == null else elegible
	
	return elegible

func _check_can_refill_cards() -> bool:
	var active_tile_cards = _get_active_tile_card_count()
	if _get_active_money_card_count() < MAX_MARKET_CARDS || (active_tile_cards > 0 && active_tile_cards <= MAX_MARKET_CARDS):
		return true
	else:
		return false

func _on_TileCard_pressed(card_node: TextureButton):
	#card_node.disconnect("pressed", self, "on_TileCard_pressed")
	(card_node as TileCardDrawable)._card_info = null
	card_node.visible = false

func _refill_tiles():
	_draw_tile($Panel/TileMarket/Card1)
	_draw_tile($Panel/TileMarket/Card2)
	_draw_tile($Panel/TileMarket/Card3)
	_draw_tile($Panel/TileMarket/Card4)
		
func _draw_tile(node: TileCardDrawable):
	if node._card_info == null:
		var card_info = Global.stack_tiles.draw_card()
		node.set_card_info(card_info)
		node.visible = true

func _on_RefillCards_pressed():
	_refill_tiles()
	
	var cards_to_refill_count = MAX_MARKET_CARDS - _get_active_money_card_count()
	for _i in range(cards_to_refill_count):
		var card = Global.stack_money.draw_card()		
		var card_node = card_scene.instance()
		card_node._card_info = card
		$Panel/MoneyMarket/MoneyCards.add_child(card_node)
		card_node.connect("pressed", self, "_on_MoneyCard_pressed", [card_node])

func _on_MoneyCard_pressed(card_node: TextureButton):
	card_node.disconnect("pressed", self, "_on_MoneyCard_pressed")
	$Panel/MoneyMarket/MoneyCards.remove_child(card_node)
	$Panel/Hand/Cards.add_child(card_node)

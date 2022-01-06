extends Node2D

export(PackedScene) var Card

var id_list =[0,1,2,1]
var number_of_cards = id_list.size()
var cardNodes =[]
var money_stack: CardStack

var title = ["color","value"]
var cardInformation = [["orange", 3],["green",7],["red",2]]

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_hand(cardInformation, id_list)
	
#func _process(delta):
#
func initialize_hand(cardInformation_in = cardInformation, id_list_in = id_list):
	id_list = id_list_in
	cardInformation = cardInformation_in
	create_all_cards(id_list)
	
	
func add_card_to_hand(cardInformation_in, id_in:int):
	
	var card = create_card(cardInformation_in, id_in, cardNodes.size())
	
	cardNodes.push_back(card)
	id_list.push_back(id_in)
	number_of_cards = id_list.size()
	
	cardNodes[-1].rect_position = Vector2(50*number_of_cards, 10*number_of_cards)
	
func create_card(cardInformation_in, id_in:int, stackPosition_in):
	var card = Card.instance()
	
	card.update_card(cardInformation_in, id_in, stackPosition_in)
	$VBoxContainer.get_node("CardHBox").add_child(card)
#	add_child(card)
	return card
	
	
func drop_card(id_in):
	var droppedPosition = id_list.find_last(id_in)
	cardNodes[droppedPosition].queue_free()
	id_list.remove(droppedPosition)
	number_of_cards = id_list.size()
	cardNodes.remove(droppedPosition)
	
	
func set_visibility(is_visible: bool):
	#this.visible = is_visible
	for card in cardNodes:
		card.visible = is_visible
	
func create_all_cards(id_list_in):
	
	var temp_id_list = id_list_in.duplicate()
	
	get_tree().call_group("cards", "queue_free")
	
	cardNodes.clear()
	id_list.clear()
	
	for n in temp_id_list.size():
		add_card_to_hand(cardInformation, temp_id_list[n])

	
func _on_TestButton_pressed():
	add_card_to_hand( cardInformation, randi() % 3 )
	set_visibility(true)

	
func _on_TestButton2_pressed():
	#drop_card(id_list[-1])
	var a = 1
	set_visibility(!cardNodes[0].visible)

func draw_card() -> MoneyCard:
	return money_stack.draw_money_card()


func _on_Button_pressed():
	var card = draw_card()
	print("Currency: %s; Value: %d" % [card._currency, card._value])
	$VBoxContainer.get_node("ButtonsHBox").get_node("DrawCard").text = "Currency: %s; Value: %d; Rest: %d" % [card._currency, card._value, money_stack.get_card_count()]

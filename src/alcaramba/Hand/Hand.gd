extends Node2D

export(PackedScene) var Card

# Declare member variables here. Examples:

var cardNodes =[]

var title = ["color","value"]
var allCards = [["orange", 5],["green",7],["blue",9]]
var id_list =[0,1,2,1]
var number_of_cards = id_list.size()

func set_allCards(cards):
	allCards = cards

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_hand(id_list)
	
#func _process(delta):
#
func initialize_hand(id_list_in = id_list):
	id_list = id_list_in
	create_hand_cards(id_list)

	
func create_hand_cards(id_list_in):
	
	var temp_id_list = id_list_in.duplicate()
	
	get_tree().call_group("cards", "queue_free")
	
	cardNodes.clear()
	id_list.clear()
	
	for n in temp_id_list.size():
		add_card_to_hand(temp_id_list[n])
		
	
func create_card(card_id:int, stackPosition_in):
	var card = Card.instance()
	card.allCards = allCards
	card.update_card(card_id, stackPosition_in)
	add_child(card)
	return card
	
func add_card_to_hand(card_id:int):
	
	var card = create_card(card_id, cardNodes.size())
	
	cardNodes.push_back(card)
	var temp = cardNodes[-1].allCards
	id_list.push_back(card_id)
	number_of_cards = id_list.size()
	
func add_cards(card_ids):
	for id in card_ids:
		add_card_to_hand(id)
	
func drop_card(card_position):
	cardNodes[card_position].queue_free()
	id_list.remove(card_position)
	number_of_cards = id_list.size()
	cardNodes.remove(card_position)
	
	
func set_visibility(is_visible: bool):
	#this.visible = is_visible
	for card in cardNodes:
		card.visible = is_visible
		
	


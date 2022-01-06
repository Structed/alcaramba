extends Node2D


# Declare member variables here. Examples:
var allCards = [["orange", 5],["green",7],["blue",9],["blue",9],["blue",10],["blue",5],["blue",2],["blue",19],["blue",1],["blue",2]]
var number_slots = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	$moneyHand.allCards = allCards
	$moneyHand.initialize_hand()
	position_cards()
	
func set_allCards(cards):
	allCards = cards

func position_cards():
	var n=0
	for card in $moneyHand.cardNodes:
		card.rect_position = Vector2(50*n, 30*n)
		n+=1

func show_card_active():
	pass

func take_money():
	var cards_taken_id = []
	for i in range($moneyHand.cardNodes.size()-1,-1,-1):
		var card = $moneyHand.cardNodes[i]
		if card.active:
			cards_taken_id.append(card.id)
			$moneyHand.drop_card(card.stackPosition)

	$moneyHand.initialize_hand()
	position_cards()
	return cards_taken_id
	
func refill_money():
	var missing = number_slots - $moneyHand.number_of_cards
	var card_ids = $moneyStack.draw_cards(missing)

	for id in card_ids:
		$moneyHand.add_card_to_hand(id)
	position_cards()

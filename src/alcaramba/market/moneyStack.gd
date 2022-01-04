extends Node2D


# Declare member variables here. Examples:

var allCards = [["orange", 5],["green",7],["blue",9],["blue",9],["blue",10]]
var id_list = []
var number_cards = allCards.size()

func set_allCards(cards):
	allCards = cards


# Called when the node enters the scene tree for the first time.
func _ready():
	create_stack()

func create_stack():
	id_list = range(number_cards)
	id_list.shuffle()
	
func draw_cards(draws):
	var ids = []
	for i in draws:
		ids.append(id_list[0])
		id_list.pop_front()
		number_cards -=1
	return ids

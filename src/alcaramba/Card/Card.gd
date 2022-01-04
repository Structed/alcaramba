extends Node2D


# Declare member variables here. Examples:
var id = 0
var color
var value
var cardSize = Vector2(100,200)

var title = ["color","value"]
var cardInformation = [[0, 3],[1,7]]


# Called when the node enters the scene tree for the first time.
func _ready():
	
	update_card(cardInformation, id)
	#! $BaseRect.visible = false
	
	
func update_card(cardInfo_in, id_in: int):
	id = id_in
	cardInformation = cardInfo_in
	var position = title.find("color")
	color =  cardInformation[id][position]
	position = title.find("value")
	value = cardInformation[id][position]
	$BaseRect.set_size(cardSize)
	$BaseRect/CardValue.text = str(value)
	

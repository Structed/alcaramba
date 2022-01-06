extends Node2D


# Declare member variables here. Examples:



# Called when the node enters the scene tree for the first time.
func _ready():
	$moneyMarket.refill_money()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_RefillMoneyButton_pressed():

	$moneyMarket.refill_money()


func _on_TakeMoneyButton_pressed():
	$moneyMarket.take_money()

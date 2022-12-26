extends Control


var card_scene = preload("res://Drawable/Card/MoneyCardDrawable.tscn")


func add_card_node(card_drawable: TextureButton):
	add_child(card_drawable)

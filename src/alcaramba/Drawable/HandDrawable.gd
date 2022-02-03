extends Control


var card_scene = preload("res://Drawable/Card/MoneyCardDrawable.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#func _add_card(card_info: MoneyCard):
#	var node = card_scene.instance()
#	node._card_info = card_info
	
func add_card_node(card_drawable: TextureButton):
	add_child(card_drawable)

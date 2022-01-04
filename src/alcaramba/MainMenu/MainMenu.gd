extends MarginContainer

signal new_game_clicked


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NewGame_pressed():
	emit_signal("new_game_clicked")


func _on_Quit_pressed():
	get_tree().quit()

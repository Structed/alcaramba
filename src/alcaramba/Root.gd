extends Node

var main_menu
var current_scene : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	main_menu = $MainMenu
	current_scene = $MainMenu
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_MainMenu_new_game_clicked():
	var handScene = load("res://Hand/Hand.tscn")
	
	$MainMenu.visible = false
	current_scene = handScene.instance()
	get_tree().get_root().add_child(current_scene)
	

extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	OverlayDebugInfo.hide()


func _on_StartGameButton_pressed():
	SceneManager.goto_scene("res://Drawable/Game/Game.tscn")

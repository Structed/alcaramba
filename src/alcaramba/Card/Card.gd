extends TextureRect


# Declare member variables here. Examples:
var id = 1
var color
var value
var active = false
#var cardSize = Vector2(100,200)

var title = ["color","value"]
var allCards = [["orange", 3],["green",7]]

var stackPosition = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	#visible=false
	update_card(id, stackPosition)
	

func _on_ActivationButton_pressed():
	active = !active
	show_is_active()
	
func update_card(id_in: int, stackPosition_in = 0):
	
	id = id_in
	stackPosition = stackPosition_in
	
	var position = title.find("color")
	color =  allCards[id][position]
	position = title.find("value")
	value = allCards[id][position]	
	texture = load("res://Card/assets/square_" + color + ".png")
	show_is_active()
	
	# cardValueLabel can be removed when textures have values printed on
	$CardValueLabel.text = str(value)
	$ActivationButton.rect_size = get_texture().get_size()
	
func set_visibility(is_visible:bool):
	visible = is_visible
	
func show_is_active():
	if active:
		rect_position -= Vector2(0,20)
	else:
		rect_position += Vector2(0,20)
	




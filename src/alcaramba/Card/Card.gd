extends TextureRect


# Declare member variables here. Examples:
var id = 0
var color
var value
var active = false
#var cardSize = Vector2(100,200)

var title = ["color","value"]
var cardInformation = [["orange", 3],["green",7]]

var stackPosition = 0



# Called when the node enters the scene tree for the first time.
func _ready():
	#visible=false
	update_card(cardInformation, id, stackPosition)
	
func _on_TestButton_pressed():
	active = !active
	update_card(cardInformation, id, stackPosition)
	
func update_card(cardInfo_in, id_in: int, stackPosition_in = 0):
	#visible = false
	id = id_in
	cardInformation = cardInfo_in
	stackPosition_in = stackPosition_in
	
	var position = title.find("color")
	color =  cardInformation[id][position]
	position = title.find("value")
	value = cardInformation[id][position]	
	texture = load("res://Card/assets/square_" + color + ".png")
	show_is_active()
	
	# cardValueLabel can be removed when textures have values printed on
	$CardValueLabel.text = str(value)
	
	#visible = true
	
func set_visibility(is_visible:bool):
	visible = is_visible
	
func show_is_active():
	if active:
		rect_position -= Vector2(0,20)
	else:
		rect_position += Vector2(0,20)
	

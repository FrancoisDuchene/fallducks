extends Sprite2D

@onready var parent = $".."

var pressing = false

@export var maxLength = 70
@export var deadZone = 30

func _ready():
	maxLength *= parent.scale.x
	deadZone *= parent.scale.x

func _process(delta):
	var angle = 0
	if pressing:
		if get_global_mouse_position().distance_to(parent.global_position) <= maxLength:
			global_position = get_global_mouse_position()
		else:
			angle = parent.global_position.angle_to_point(get_global_mouse_position())
			global_position.x = parent.global_position.x + cos(angle)*maxLength
			global_position.y = parent.global_position.y + sin(angle)*maxLength
		calculateVector()
	else:
		global_position = lerp(global_position, parent.global_position, delta*10)
		parent.posVector = Vector2(0, 0)
	print("global_position:", global_position, "\tangle:", angle, "\tget_global_mouse_position()", get_global_mouse_position())


func calculateVector():
	if abs(global_position.x - parent.global_position.x) >= deadZone:
		parent.posVector.x = (global_position.x - parent.global_position.x) / maxLength
	else:
		parent.posVector.x = 0
	if abs(global_position.y - parent.global_position.y) >= deadZone:
		parent.posVector.y = (global_position.y - parent.global_position.y) / maxLength
	else:
		parent.posVector.y = 0
		

func _on_button_button_down():
	pressing = true


func _on_button_button_up():
	pressing = false

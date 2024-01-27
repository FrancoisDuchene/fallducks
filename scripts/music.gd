extends AudioStreamPlayer

const DUCK_SPEED = preload("res://scripts/enums/duck_speed.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_speed_changed(duck_speed):
	if duck_speed == DUCK_SPEED.SLOW_THE_FUCK_DOWN:
		pitch_scale = 0.5
	elif duck_speed == DUCK_SPEED.THIS_IS_FINE:
		pitch_scale = 1
	elif duck_speed == DUCK_SPEED.GOTTA_GO_FAST:
		pitch_scale = 15
	else:
		print("Fuck you!")

extends ParallaxBackground

const DUCK_SPEED = preload("res://scripts/enums/duck_speed.gd")

var game_ongoing = false
var scroll_speed = 150

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_ongoing:
		scroll_offset.y -= scroll_speed * delta
	
func _on_main_launch_game():
	game_ongoing = true

func _on__main_stop_game():
	game_ongoing = false
	
func _on_player_speed_changed(duck_speed):
	if duck_speed == DUCK_SPEED.SLOW_THE_FUCK_DOWN:
		scroll_speed = 75
	elif duck_speed == DUCK_SPEED.THIS_IS_FINE:
		scroll_speed =  150
	elif duck_speed == DUCK_SPEED.GOTTA_GO_FAST:
		scroll_speed = 500
	else:
		print("Fuck you!")

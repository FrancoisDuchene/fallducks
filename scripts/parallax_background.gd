extends ParallaxBackground

const DUCK_SPEED = preload("res://scripts/enums/duck_speed.gd")
const BASE_SCROLL_SPEED = 40
var game_ongoing = false
var current_scroll_speed = BASE_SCROLL_SPEED * DUCK_SPEED.THIS_IS_FINE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_ongoing:
		scroll_offset.y -= current_scroll_speed * delta
	
func _on_main_launch_game():
	game_ongoing = true

func _on__main_stop_game():
	game_ongoing = false
	
func _on_player_speed_changed(duck_speed):
	current_scroll_speed = BASE_SCROLL_SPEED * duck_speed


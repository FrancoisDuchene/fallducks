extends ParallaxBackground

var game_ongoing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_ongoing:
		scroll_offset.y -= 100 * delta
	
func _on_main_launch_game():
	game_ongoing = true

func _on__main_stop_game():
	game_ongoing = false

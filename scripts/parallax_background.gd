extends ParallaxBackground

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
	
func _on_player_gotta_go_fast():
	scroll_speed = 500
	
func _on_player_gotta_go_normal():
	scroll_speed =  150
	
func _on_player_plus_vite_que_l_traiiiinnn():
	scroll_speed = 75
	

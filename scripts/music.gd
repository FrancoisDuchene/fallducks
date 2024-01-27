extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_gotta_go_fast():
	pitch_scale = 1.5

func _on_player_gotta_go_normal():
	pitch_scale = 1
	
func _on_player_plus_vite_que_l_traiiiinnn():
	pitch_scale = 0.5

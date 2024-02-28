extends AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func fit_goose_to_screen(screen_size: Vector2):
	var goose_y_start = screen_size.y + $judgingGoose.get_texture().get_height()
	var goose_y_center = screen_size.y - 0.5*$judgingGoose.get_texture().get_height()
	$judgingGoose.position.y = goose_y_start
	
	get_animation("goose_appear").track_set_key_value(1,0,[$judgingGoose.position.y,-0.25,0,0.25,0])
	get_animation("goose_appear").track_set_key_value(1,1,[goose_y_center,-0.25,0,0.25,0])
	
	get_animation("goose_dissapear").track_set_key_value(1,0,[goose_y_center,-0.25,0,0.25,0])
	get_animation("goose_dissapear").track_set_key_value(1,1,[$judgingGoose.position.y,-0.25,0,0.25,0])

extends Path2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func fit_to_screen(screen_size: Vector2):
	var p1 = get_curve().get_point_position(0)
	var p2 = get_curve().get_point_position(1)
	
	get_curve().clear_points()
	
	get_curve().add_point(Vector2(p1.x,screen_size.y),Vector2(0,0),Vector2(0,0),0)
	get_curve().add_point(Vector2(p2.x,screen_size.y),Vector2(0,0),Vector2(0,0),1)

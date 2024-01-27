extends RigidBody2D

var fast_scrolling_velocity: float = 300
var normal_scrolling_velocity: float = 180
var slow_scrolling_velocity: float = 100

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _process(delta):
	pass

func _ready():
	# Typically could animate the platform, but it's a rock so what's the point?
	# Let's leave to the caller of this object the role of changing its horizontal scale
	gravity_scale = 0
	constant_force = Vector2.ZERO

func scale(x):
	var ps = $PlatformSprite
	var collision_polygon = $CollisionPolygon2D
	var polygon = collision_polygon.polygon
	var scale_vector = Vector2(x, x)
	
	ps.scale = scale_vector
	$VisibleOnScreenNotifier2D.set_scale(scale_vector)
	# scale each vertex
	for i in polygon.size():
		polygon.set(i, polygon[i] * scale_vector)
	$CollisionPolygon2D.polygon = polygon

func _on_player_gotta_go_fast():
	self.linear_velocity = Vector2(0, -fast_scrolling_velocity)
	
func _on_player_gotta_go_normal():
	linear_velocity = Vector2(0, -normal_scrolling_velocity)
	
func _on_player_plus_vite_que_l_traiiiinnn():
	linear_velocity = Vector2(0, -slow_scrolling_velocity)

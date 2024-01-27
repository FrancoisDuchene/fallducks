extends RigidBody2D

const DUCK_SPEED = preload("res://scripts/enums/duck_speed.gd")

const fast_scrolling_velocity: float = 600
const normal_scrolling_velocity: float = 180
const slow_scrolling_velocity: float = 110

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

func _on_player_speed_changed(duck_speed):
	if duck_speed == DUCK_SPEED.SLOW_THE_FUCK_DOWN:
		self.linear_velocity = Vector2(0, -slow_scrolling_velocity)
	elif duck_speed == DUCK_SPEED.THIS_IS_FINE:
		self.linear_velocity = Vector2(0, -normal_scrolling_velocity)
	elif duck_speed == DUCK_SPEED.GOTTA_GO_FAST:
		self.linear_velocity = Vector2(0, -fast_scrolling_velocity)
	else:
		print("Fuck you!")

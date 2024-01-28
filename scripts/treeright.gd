extends RigidBody2D

const DUCK_SPEED = preload("res://scripts/enums/duck_speed.gd")

# TODO move this to some global context
const BASE_SCROLLING_VELOCITY: float = 60.0

var velocity = Vector2.ZERO

func _on_player_speed_changed(duck_speed):
	process_speed_update(duck_speed)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _process(delta):
	pass

func _ready():
	# Typically could animate the platform, but it's a rock so what's the point?
	# Let's leave to the caller of this object the role of changing its horizontal scale
	gravity_scale = 0
	constant_force = Vector2.ZERO

func init(scale_factor: float, initial_duck_speed):
	process_speed_update(initial_duck_speed)
	scale_objects(scale_factor)

func process_speed_update(duck_speed):
	var velocity_y = BASE_SCROLLING_VELOCITY * duck_speed
	self.velocity = Vector2(0, -velocity_y)
	self.linear_velocity = self.velocity

func scale_objects(x):
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

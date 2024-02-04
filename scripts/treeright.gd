extends RigidBody2D

const DUCK_SPEED = preload("res://scripts/enums/duck_speed.gd")

# TODO move this to some global context
const BASE_SCROLLING_VELOCITY: float = 108

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

func init(initial_duck_speed):
	process_speed_update(initial_duck_speed)

func process_speed_update(duck_speed):
	var velocity_y = BASE_SCROLLING_VELOCITY * duck_speed
	self.velocity = Vector2(0, -velocity_y)
	self.linear_velocity = self.velocity



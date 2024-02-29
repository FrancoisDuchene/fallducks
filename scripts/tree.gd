extends RigidBody2D

const DUCK_SPEED = preload("res://scripts/enums/duck_speed.gd")

# TODO move this to some global context
const BASE_SCROLLING_VELOCITY: float = 108
# -720 is the normal speed which was quite hard, so /5 it's 144; let's reduce that by 25%

var velocity = Vector2.ZERO

func _on_player_speed_changed(duck_speed):
	process_speed_update(duck_speed)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _process(_delta):
	pass

func _ready():
	# TODO need to change this so that the tree is anchored on the side of the screen
	gravity_scale = 0
	constant_force = Vector2.ZERO

func init(initial_duck_speed, flip: bool = false):
	process_speed_update(initial_duck_speed)
	if flip:
		flip_scene()

func process_speed_update(duck_speed):
	var velocity_y = BASE_SCROLLING_VELOCITY * duck_speed
	self.velocity = Vector2(0, -velocity_y)
	self.linear_velocity = self.velocity

func flip_scene():
	var sprite: Sprite2D = $TreeSprite
	var collision_box: CollisionPolygon2D = $CollisionPolygon2D
	var collision_polygon: PackedVector2Array = collision_box.polygon
	var scaler = Vector2(-1, 1)
	sprite.scale *= scaler
	for i in collision_polygon.size():
		collision_polygon.set(i, collision_polygon[i] * scaler)
	collision_box.polygon = collision_polygon
	$VisibleOnScreenNotifier2D.scale *= scaler

extends RigidBody2D

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
	var cb = $CollisionBox
	# The icon is 64x64 pixels, we scale it up to 320 x 64 pixels
	ps.scale = Vector2(x, 1)
	cb.shape.size[0] = x * 128

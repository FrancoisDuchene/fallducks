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
	var collision_polygon = $CollisionPolygon2D
	var polygon = collision_polygon.polygon
	var scale_vector = Vector2(x, x)
	
	ps.scale = scale_vector
	$VisibleOnScreenNotifier2D.set_scale(scale_vector)
	# scale each vertex
	for i in polygon.size():
		polygon.set(i, polygon[i] * scale_vector)
	$CollisionPolygon2D.polygon = polygon

extends Area2D

signal hit

@export var speed = 400
var screen_size: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity_x = Input.get_axis("move_left", "move_right")
	# If the player presses both buttons, he doesn't move I guess?
	if abs(velocity_x) > 0:
		velocity_x *= speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	var velocity = Vector2(velocity_x, 0)
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)


func _on_body_entered(body):
	$TouchedSound.play()
	hide()
	hit.emit()
	$CollisionPolygon2D.set_deferred("disabled", true) # Disable to avoid receiving lots of hit signals

func start(pos):
	position = pos
	show()
	$CollisionPolygon2D.disabled = false

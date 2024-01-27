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
	var velocity_y = Input.get_axis("move_up", "move_down")
	
	if velocity_y > 0:
		# Faster speed
		if abs(velocity_x) > 0:
			velocity_x *= speed
			$AnimatedSprite2D.play("TurnFast")
		else:
			$AnimatedSprite2D.play("IdleFast")
			#$AnimatedSprite2D.stop() 
	elif velocity_y < 0:
		# Slower speed
		if abs(velocity_x) > 0:
			velocity_x *= speed
			$AnimatedSprite2D.play("TurnSlow")
		else:
			$AnimatedSprite2D.play("IdleSlow")
			#$AnimatedSprite2D.stop() 
	else:
		# Normal speed
		if abs(velocity_x) > 0:
			velocity_x *= speed
			$AnimatedSprite2D.play("TurnNormal")
		else:
			$AnimatedSprite2D.play("IdleNormal")
			#$AnimatedSprite2D.stop() 
	
	# If the player presses both buttons, he doesn't move I guess?
	#if abs(velocity_x) > 0:
		#velocity_x *= speed
		#$AnimatedSprite2D.play("TurnNormal")
	#else:
		#$AnimatedSprite2D.stop()
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

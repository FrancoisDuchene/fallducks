extends Area2D

signal hit

@export var speed = 400
var screen_size: Vector2
var last_touch_position = Vector2.ZERO

func _input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			last_touch_position = event.get_position()
		if event.is_released():
			last_touch_position = null
	elif event is InputEventMouse:
		var e = (event as InputEventMouse)
		if e.button_mask & MOUSE_BUTTON_LEFT:
			last_touch_position = event.get_global_position()
		else:
			last_touch_position = null

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	var velocity_x = process_inputs()
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

func get_velocity_from_screentouch():
	if last_touch_position == null:
		return 0
	else:
		var touch_pos_x = last_touch_position[0]
		# if touch_pos_x = 0 -> strength = -1, if touch_pos_x = screen_size[0] -> strength = +1
		var strength = (2 * touch_pos_x / screen_size[0]) - 1
		return strength

func process_inputs():
	var velocity_x_from_axis = Input.get_axis("move_left", "move_right")
	var velocity_x_from_screentouch = get_velocity_from_screentouch()
	if abs(velocity_x_from_screentouch) > 0:
		return velocity_x_from_screentouch
	else:
		return velocity_x_from_axis

func start(pos):
	position = pos
	show()
	$CollisionPolygon2D.disabled = false

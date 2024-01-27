extends Area2D

signal hit

@export var speed = 400
var screen_size: Vector2
var default_pos_y = 0

signal gotta_go_fast
signal gotta_go_normal
signal plus_vite_que_l_traiiiinnn


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
	self.gotta_go_fast.connect(get_parent().get_node("ParallaxBackground")._on_player_gotta_go_fast)
	self.gotta_go_normal.connect(get_parent().get_node("ParallaxBackground")._on_player_gotta_go_normal)
	self.plus_vite_que_l_traiiiinnn.connect(get_parent().get_node("ParallaxBackground")._on_player_plus_vite_que_l_traiiiinnn)
	# music
	self.gotta_go_fast.connect(get_parent().get_node("Music")._on_player_gotta_go_fast)
	self.gotta_go_normal.connect(get_parent().get_node("Music")._on_player_gotta_go_normal)
	self.plus_vite_que_l_traiiiinnn.connect(get_parent().get_node("Music")._on_player_plus_vite_que_l_traiiiinnn)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity_x = process_inputs()
	var velocity_y = Input.get_axis("move_up", "move_down")
	var position_y = default_pos_y
	
	if velocity_y > 0:
		# Faster speed
		gotta_go_fast.emit()
		position_y = position_y + 150
		if abs(velocity_x) > 0:
			velocity_x *= speed / 1.5
			$AnimatedSprite2D.play("TurnFast")
		else:
			$AnimatedSprite2D.play("IdleFast")
			#$AnimatedSprite2D.stop() 
	elif velocity_y < 0:
		# Slower speed
		plus_vite_que_l_traiiiinnn.emit()
		position_y = position_y - 100
		if abs(velocity_x) > 0:
			velocity_x *= speed
			$AnimatedSprite2D.play("TurnSlow")
		else:
			$AnimatedSprite2D.play("IdleSlow")
			#$AnimatedSprite2D.stop() 
	else:
		# Normal speed
		gotta_go_normal.emit()
		if abs(velocity_x) > 0:
			velocity_x *= speed * 1.2
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
	var position2 = position
	position2.y = position_y
	
	position = position.lerp(position2, delta*5)
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
	default_pos_y = pos.y
	show()
	$CollisionPolygon2D.disabled = false

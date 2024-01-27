extends Area2D

signal hit

@export var speed = 400
var screen_size: Vector2
var default_pos_y = 0

signal gotta_go_fast
signal gotta_go_normal
signal plus_vite_que_l_traiiiinnn




# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	self.gotta_go_fast.connect(get_parent().get_node("ParallaxBackground")._on_player_gotta_go_fast)
	self.gotta_go_normal.connect(get_parent().get_node("ParallaxBackground")._on_player_gotta_go_normal)
	self.plus_vite_que_l_traiiiinnn.connect(get_parent().get_node("ParallaxBackground")._on_player_plus_vite_que_l_traiiiinnn)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity_x = Input.get_axis("move_left", "move_right")
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

func start(pos):
	position = pos
	default_pos_y = pos.y
	show()
	$CollisionPolygon2D.disabled = false

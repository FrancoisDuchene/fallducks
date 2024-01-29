extends Area2D

const DUCK_SPEED = preload("res://scripts/enums/duck_speed.gd")

signal dead
signal speed_changed
signal hit
signal health_update

const MAX_HEALTH = 4
const MAX_TEMPO = 3.0
const SPEED = 400

@export var pos_y = 0
@export var pos_x = 0
@export var health = MAX_HEALTH
@export var tempo = MAX_TEMPO
@onready var parent = $".."
@onready var joystick = parent.find_child("joystick")

var screen_size: Vector2
var default_pos_y = 0
var last_touch_position = Vector2.ZERO
var player_speed_mode = DUCK_SPEED.THIS_IS_FINE
var previous_speed_mode = DUCK_SPEED.THIS_IS_FINE


func _on_player_speed_changed(duck_speed):
	print("Received signal of speed change: ", duck_speed)
	self.player_speed_mode = duck_speed

func _ready():
	screen_size = get_viewport_rect().size
	# background
	self.speed_changed.connect(get_parent().get_node("ParallaxBackground")._on_player_speed_changed)
	# music
	self.speed_changed.connect(get_parent().get_node("Music")._on_player_speed_changed)
	# score counter
	self.speed_changed.connect(get_parent()._on_player_speed_changed)
		

func _process(delta):
	var velocity_x = process_inputs()
	var moving = abs(velocity_x) > 0

	if not $CollisionPolygon2D.call_deferred("is_disabled"):
		if tempo < 0:
			$CollisionPolygon2D.set_deferred("disabled", false)
			tempo = MAX_TEMPO
		else:
			tempo -= delta

	var stable_position_y = default_pos_y
	# will contain the stable position's height (up when slow, down when fast, middle when normal)
	# when not accelerating towards its stable position
	match player_speed_mode:
		DUCK_SPEED.GOTTA_GO_FAST:
			stable_position_y = stable_position_y + 150
			if moving:
				velocity_x *= SPEED / 1.5
			choose_sprite("fast", moving, health)
		DUCK_SPEED.SLOW_THE_FUCK_DOWN:
			stable_position_y = stable_position_y - 100
			if moving:
				velocity_x *= SPEED
			choose_sprite("slow", moving, health)
		DUCK_SPEED.THIS_IS_FINE:
			if moving:
				velocity_x *= SPEED * 1.2
			choose_sprite("normal", moving, health)

	var velocity = Vector2(velocity_x, 0)
	 # This is the actual position before we try to accelerate it to its stable position;
	# it may be offset from the stable position and needs to be brought back progressively
	position += velocity * delta

	# Copy the position and change it to reflect the stable position
	var position2 = position
	position2.y = stable_position_y

	# Interpolate; it takes 0.2s to reach the stable position
	position = position.lerp(position2, delta*5)
	position = position.clamp(Vector2.ZERO, screen_size)
	pos_x = position2.x

func _on_body_entered(body):
	hit.emit()

func _on_player_hit():
	health -= 1
	health_update.emit()
	if GlobalProperties.sound_on:
		$TouchedSound.play()
	#$CollisionPolygon2D.set_deferred("disabled", true) # Disable to avoid receiving lots of hit signals
	$CollisionPolygon2D.disabled = true
	if health < 1:
		hide()
		dead.emit()

func get_inputs() -> Vector2:
	var velocity: Vector2 = joystick.posVector
	if velocity.length() > 0:
		return velocity
	var velocity_x = Input.get_axis("move_left", "move_right")
	var velocity_y = Input.get_axis("move_up", "move_down")
	return Vector2(velocity_x, velocity_y)

func process_inputs():
	# Get inputs
	var velocity_vector = get_inputs()

	# Post-process input y
	var mode = null
	if velocity_vector.y < 0:
		# Slow down
		mode = DUCK_SPEED.SLOW_THE_FUCK_DOWN
	elif velocity_vector.y > 0:
		# Speed up
		mode = DUCK_SPEED.GOTTA_GO_FAST
	else:
		# Normal speed
		mode = DUCK_SPEED.THIS_IS_FINE
	if previous_speed_mode != mode:
		speed_changed.emit(mode)
	previous_speed_mode = mode
	self.player_speed_mode = mode
	return velocity_vector.x

func start(pos):
	health = MAX_HEALTH
	position = pos
	default_pos_y = pos.y
	show()
	$CollisionPolygon2D.disabled = false


func choose_sprite(speed, turn, health):
	match speed:
		"slow":
			match health:
				4:
					if turn:
						$AnimatedSprite2D.play("TurnSlowHurt0")
					else:
						$AnimatedSprite2D.play("IdleSlowHurt0")
				3:
					if turn:
						$AnimatedSprite2D.play("TurnSlowHurt1")
					else:
						$AnimatedSprite2D.play("IdleSlowHurt1")
				2:
					if turn:
						$AnimatedSprite2D.play("TurnSlowHurt2")
					else:
						$AnimatedSprite2D.play("IdleSlowHurt2")
				1:
					if turn:
						$AnimatedSprite2D.play("TurnSlowHurt3")
					else:
						$AnimatedSprite2D.play("IdleSlowHurt3")
		"normal":
			match health:
				4:
					if turn:
						$AnimatedSprite2D.play("TurnNormalHurt0")
					else:
						$AnimatedSprite2D.play("IdleNormalHurt0")
				3:
					if turn:
						$AnimatedSprite2D.play("TurnNormalHurt1")
					else:
						$AnimatedSprite2D.play("IdleNormalHurt1")
				2:
					if turn:
						$AnimatedSprite2D.play("TurnNormalHurt2")
					else:
						$AnimatedSprite2D.play("IdleNormalHurt2")
				1:
					if turn:
						$AnimatedSprite2D.play("TurnNormalHurt3")
					else:
						$AnimatedSprite2D.play("IdleNormalHurt3")
		"fast":
			match health:
				4:
					if turn:
						$AnimatedSprite2D.play("TurnFastHurt0")
					else:
						$AnimatedSprite2D.play("IdleFastHurt0")
				3:
					if turn:
						$AnimatedSprite2D.play("TurnFastHurt1")
					else:
						$AnimatedSprite2D.play("IdleFastHurt1")
				2:
					if turn:
						$AnimatedSprite2D.play("TurnFastHurt2")
					else:
						$AnimatedSprite2D.play("IdleFastHurt2")
				1:
					if turn:
						$AnimatedSprite2D.play("TurnFastHurt3")
					else:
						$AnimatedSprite2D.play("IdleFastHurt3")
	

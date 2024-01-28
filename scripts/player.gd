extends Area2D

const DUCK_SPEED = preload("res://scripts/enums/duck_speed.gd")

signal dead
signal speed_changed
signal hit

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


func _ready():
	screen_size = get_viewport_rect().size
	# background
	self.speed_changed.connect(get_parent().get_node("ParallaxBackground")._on_player_speed_changed)
	# music
	self.speed_changed.connect(get_parent().get_node("Music")._on_player_speed_changed)
	# score counter
	self.speed_changed.connect(get_parent()._on_player_speed_changed)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = process_inputs()
	var position_y = default_pos_y
	
	if not $CollisionPolygon2D.call_deferred("disabled"):
		if tempo < 0:
			$CollisionPolygon2D.set_deferred("disabled", false)
			tempo = MAX_TEMPO
		else:
			tempo -= delta
	
	if velocity.y > 0:
		# Faster speed
		speed_changed.emit(DUCK_SPEED.GOTTA_GO_FAST)
		position_y = position_y + 150
		if abs(velocity.x) > 0:
			velocity.x *= SPEED / 1.5
		choose_sprite("fast", abs(velocity.x) > 0, health)
	elif velocity.y < 0:
		# Slower speed
		speed_changed.emit(DUCK_SPEED.SLOW_THE_FUCK_DOWN)
		position_y = position_y - 100
		if abs(velocity.x) > 0:
			velocity.x *= SPEED
		choose_sprite("slow", abs(velocity.x) > 0, health)
	else:
		# Normal speed
		speed_changed.emit(DUCK_SPEED.THIS_IS_FINE)
		if abs(velocity.x) > 0:
			velocity.x *= SPEED * 1.2
		choose_sprite("normal", abs(velocity.x) > 0, health)
	
	position += Vector2(velocity.x, 0) * delta
	var position2 = position
	position2.y = position_y
	position = position.lerp(position2, delta*5)
	position = position.clamp(Vector2.ZERO, screen_size)
	pos_x = position2.x


func _on_body_entered(body):
	hit.emit()

func _on_player_hit():
	health -= 1
	if GlobalProperties.audio_on:
		$TouchedSound.play()
	$CollisionPolygon2D.set_deferred("disabled", true) # Disable to avoid receiving lots of hit signals
	if health < 1:
		hide()
		dead.emit()

func process_inputs():
	var velocity: Vector2 = joystick.posVector
	if velocity.length() > 0:
		return velocity
	var velocity_x = Input.get_axis("move_left", "move_right")
	var velocity_y = Input.get_axis("move_up", "move_down")
	return Vector2(velocity_x, velocity_y)

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
	

extends Node

const DUCK_SPEED = preload("res://scripts/enums/duck_speed.gd")

signal launch_game
signal stop_game

@export var mob_scene: PackedScene
@export var eagle_scene: PackedScene

const BASE_VELOCITY = 1.0 # m/s

var score: float # m
var scrolling_velocity: float = 180
var current_speed = BASE_VELOCITY * DUCK_SPEED.THIS_IS_FINE # m/s
var score_timer_steps = 0 # s

func _on_hud_start_game():
	new_game()
	$StartSound.pitch_scale = randf_range(0.3, 2.0)
	$StartSound.play()

func _on_player_hit():
	game_over()

func _on_score_timer_timeout():
	score += score_timer_steps * current_speed # m
	$Music.pitch_scale += 0.02
	$HUD.update_score(score)
	
func _on_spawn_eagle_timer_timeout():
	var eagle_platform = eagle_scene.instantiate()
	# Choose random x location, along the path
	var eagle_spawn_location = $EaglePassingBySpawnPath/EagleFollowLocation
	eagle_spawn_location.progress_ratio = randf()
	eagle_platform.position = eagle_spawn_location.position
	# This is a RigidBody, it can move by itself if given an initial velocity
	eagle_platform.linear_velocity = Vector2(0, scrolling_velocity)
	add_child(eagle_platform)

func _on_spawn_rock_platform_timer_timeout():
	var rock_platform = mob_scene.instantiate()

	# Use a random length for the platform, within bounds, 2-5
	var scale_multiplier = (randf() * 0.2) + 0.2
	rock_platform.scale(scale_multiplier)

	# Choose random x location, along the path
	var rock_platform_spawn_location = $BottomRockSpawnPath/RockFollowLocation
	rock_platform_spawn_location.progress_ratio = randf()
	rock_platform.position = rock_platform_spawn_location.position

	# This is a RigidBody, it can move by itself if given an initial velocity
	rock_platform.linear_velocity = Vector2(0, -scrolling_velocity)

	add_child(rock_platform)
	
	# Listen to speed changes	
	$Player.speed_changed.connect(rock_platform._on_player_speed_changed)

func _on_start_delay_timer_timeout():
	$Music.pitch_scale = 0.1
	$Music.play()
	$SpawnRockPlatformTimer.start()
	$EagleSpawnTimer.start()
	$ScoreTimer.start()
	
func _on_player_speed_changed(duck_speed):
	current_speed = BASE_VELOCITY * duck_speed

func _process(delta):
	pass

func _ready():
	score_timer_steps = $ScoreTimer.wait_time
	pass
	#new_game()

func game_over():
	$Music.stop()
	$ScoreTimer.stop()
	$SpawnRockPlatformTimer.stop()
	$EagleSpawnTimer.stop()
	$HUD.show_game_over()
	stop_game.emit()

func new_game():
	score = 0
	get_tree().call_group("mobs", "queue_free")
	$Player.start($DuckStartPosition.position)
	$StartDelayTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready", true)
	launch_game.emit()

func _on_music_finished():
	$Music.play()

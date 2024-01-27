extends Node
signal launch_game
signal stop_game

@export var mob_scene: PackedScene
var score: int
var scrolling_velocity: float = 180

func _on_hud_start_game():
	new_game()

func _on_player_hit():
	game_over()

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

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

func _on_start_delay_timer_timeout():
	$SpawnRockPlatformTimer.start()
	$ScoreTimer.start()

func _process(delta):
	pass

func _ready():
	pass
	#new_game()

func game_over():
	$ScoreTimer.stop()
	$SpawnRockPlatformTimer.stop()
	$HUD.show_game_over()
	stop_game.emit()

func new_game():
	score = 0
	$Player.start($DuckStartPosition.position)
	$StartDelayTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready", true)
	launch_game.emit()
	
	

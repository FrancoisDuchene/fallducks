extends Node

const DUCK_SPEED = preload("res://scripts/enums/duck_speed.gd")

signal launch_game
signal stop_game

@export var mob_scene: PackedScene
@export var eagle_scene: PackedScene
@export var left_tree_scene: PackedScene
@export var right_tree_scene: PackedScene

@onready var joystick = $joystick


const EAGLE_BASE_COOLDOWN: float = 2 # seconds
const TREE_BASE_COOLDOWN: float = 3 # seconds
const ROCK_BASE_COOLDOWN: float = 1.5 # seconds
var event_timer_timeout_id = 0

const BASE_VELOCITY: float = 1 # m/seconds
var current_speed = BASE_VELOCITY * DUCK_SPEED.THIS_IS_FINE # m/seconds
var current_duck_speed_state = DUCK_SPEED.THIS_IS_FINE
const Max_Screen_Size = 720 # TODO Déterminer de manière dynamique

var nbr_of_death_count = 0
var score: float # m
var scrolling_velocity: float = 180
var stats = Stats.new()
var score_timer_steps = 0 # seconds
var current_difficulty = 1
var is_goose_shown = false

func _on_hud_start_game():
	new_game()
	if GlobalProperties.sound_on:
		$StartSound.pitch_scale = randf_range(0.3, 2.0)
		$StartSound.play()

func _on_player_dead():
	game_over()

func _on_score_timer_timeout():
	score += score_timer_steps * current_speed # m
	update_current_difficulty(score)
	$HUD.update_score(score)
	
	
func _on_game_event_timer_timeout():
	# Adapt spawn rate wrt. speed
	var rock_cooldown = ROCK_BASE_COOLDOWN / (current_duck_speed_state as float / DUCK_SPEED.THIS_IS_FINE)
	# Adapt spawn rate wrt. difficulty
	rock_cooldown = rock_cooldown / current_difficulty
	var game_event_timer_step = $GameEventTimer.wait_time # seconds
	var required_eagle_cooldown_steps = (EAGLE_BASE_COOLDOWN / game_event_timer_step) as int
	var required_rock_cooldown_steps = (rock_cooldown / game_event_timer_step) as int
	var required_tree_cooldown_steps = (TREE_BASE_COOLDOWN / game_event_timer_step) as int
	# Spawn eagles
	if event_timer_timeout_id % required_eagle_cooldown_steps == 0:
		var eagle_lotto = randi_range(0,3)
		if eagle_lotto == 0:
			# display eagle alert in HUD
			$HUD.display_eagle_alert()
			# Eagle will spawn after timeout
			$EagleSpawnTimer.start()
	# Spawn rocks
	if event_timer_timeout_id % required_rock_cooldown_steps == 0:
		spawn_rock()
	#if event_timer_timeout_id % required_rock_cooldown_steps == 0:
	#	spawn_tree()
	
	event_timer_timeout_id += 1
	
func _on_eagle_spawn_timer_timeout():
	# Stop eagle alert
	$HUD.hide_eagle_alert()
	# Create eagle
	var eagle_platform = eagle_scene.instantiate()
	# Choose random x location, along the path
	var eagle_spawn_location = $EaglePassingBySpawnPath/EagleFollowLocation
	var size = get_tree().get_root().size
	eagle_spawn_location.progress_ratio = 1 - ($Player.pos_x/Max_Screen_Size)
	eagle_platform.position = eagle_spawn_location.position
	# This is a RigidBody, it can move by itself if given an initial velocity
	eagle_platform.linear_velocity = Vector2(0, scrolling_velocity)
	add_child(eagle_platform)

func spawn_tree():
	var tree_spawn_location = $TreeSpawn/TreeFollow
	# First flip a coin to see if we generate a tree on left side
	if randi() % 2 == 0:
		var tree_platform = left_tree_scene.instantiate()
		tree_spawn_location.progress_ratio = 1.0
		tree_platform.position = tree_spawn_location.position
		# This is a RigidBody, it can move by itself if given an initial velocity
		# base speed was -4*180=-720
		tree_platform.init(current_duck_speed_state)
		add_child(tree_platform)
		$Player.speed_changed.connect(tree_platform._on_player_speed_changed)
	# Second flip a coin to see if we generate a tree on right side
	if randi() % 2 == 0:
		var tree_platform = right_tree_scene.instantiate()
		tree_spawn_location.progress_ratio = 0.0
		tree_platform.position = tree_spawn_location.position
		# This is a RigidBody, it can move by itself if given an initial velocity
		tree_platform.init(current_duck_speed_state)
		add_child(tree_platform)
		$Player.speed_changed.connect(tree_platform._on_player_speed_changed)

func spawn_rock():
	var rock_platform = mob_scene.instantiate()

	# Use a random length for the platform, within bounds, 2-5
	var scale_multiplier = (randf() * 0.2) + 0.2
	rock_platform.init(scale_multiplier, current_duck_speed_state)

	# Choose random x location, along the path
	var rock_platform_spawn_location = $BottomRockSpawnPath/RockFollowLocation
	rock_platform_spawn_location.progress_ratio = randf()
	rock_platform.position = rock_platform_spawn_location.position

	add_child(rock_platform)

	# Listen to speed changes	
	$Player.speed_changed.connect(rock_platform._on_player_speed_changed)

# Lowest difficult = 1, 2 = twice the difficulty, etc.
func update_current_difficulty(score: float):
	current_difficulty = log(score/400+1)+1

func _on_start_delay_timer_timeout():
	if GlobalProperties.music_on:
		$Music.play()
	$SpawnRockPlatformTimer.start()
	$GameEventTimer.start()
	$ScoreTimer.start()
	$TreeSpawnTimer.start()
	
func _on_player_speed_changed(duck_speed):
	current_speed = BASE_VELOCITY * duck_speed
	current_duck_speed_state = duck_speed

func _process(delta):
	pass

func _ready():
	score_timer_steps = $ScoreTimer.wait_time
	$HUD.start_the_game()
	
func game_over():
	if GlobalProperties.music_on:
		$Music.stop()
	$ScoreTimer.stop()
	$SpawnRockPlatformTimer.stop()
	$GameEventTimer.stop()
	$TreeSpawnTimer.stop()
	$HUD.show_game_over()
	nbr_of_death_count += 1
	if (nbr_of_death_count > 5 or score <= 100) and randi_range(0,2) == 0:
		make_judging_goose_appears()
	if stats.update_high_score(score):
		print("New high score of %d !!" % score)
	stop_game.emit()

func new_game():
	score = 0
	get_tree().call_group("mobs", "queue_free")
	$Player.start($DuckStartPosition.position)
	$StartDelayTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready", true)
	if is_goose_shown:
		$AnimationPlayerGoose.play("goose_dissapear")
		is_goose_shown = false
	launch_game.emit()
	handle_hearts()

func _on_player_health_update():
	handle_hearts()

func handle_hearts():
	$Heartfilled.visible = $Player.health >= 1
	$Heartfilled2.visible = $Player.health >= 2
	$Heartfilled3.visible = $Player.health >= 3
	$Heartfilled4.visible = $Player.health >= 4
		

func _on_music_finished():
	if GlobalProperties.music_on:
		$Music.play()
		
func make_judging_goose_appears():
	$AnimationPlayerGoose.play("goose_appear")
	is_goose_shown = true

extends Control

@export var MenuPlayer: PackedScene

func _on_spawn_duck():
	var new_duck = MenuPlayer.instantiate()
	var duck_spawn_location = $DuckSpawnPath/DuckSpawnFollow
	duck_spawn_location.progress_ratio = randf()
	new_duck.position = duck_spawn_location.position
	new_duck.rotation = randf() * 2 * PI
	print("Spawned duck at ", new_duck.position, ", ", new_duck.rotation)
	add_child(new_duck)

# Called when the node enters the scene tree for the first time.
func _ready():
	var blue_lotto = randf_range(0.0,1.0)
	$Background.material.set_shader_parameter("blue",blue_lotto)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_single_player_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_option_button_pressed():
	get_tree().change_scene_to_file("res://scenes/options.tscn")
	

func _on_credit_button_pressed():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")


func _on_quit_button_pressed():
	get_tree().quit()


extends Control


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


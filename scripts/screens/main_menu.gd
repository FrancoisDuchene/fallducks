extends Control



var _sound_btn_sound_on = load("res://art/sprites/ui/icone_son_plein.svg")
var _sound_btn_sound_off = load ("res://art/sprites/ui/icone_son_coupe.svg")
var _toggle_sound_on = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

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


func _on_sound_button_pressed():
	if _toggle_sound_on:
		$SoundButton.texture_normal = _sound_btn_sound_off
		_toggle_sound_on = false
		GlobalProperties.audio_on = false
		print(GlobalProperties.audio_on)
	else:
		$SoundButton.texture_normal = _sound_btn_sound_on
		_toggle_sound_on = true
		GlobalProperties.audio_on = true
		print(GlobalProperties.audio_on)

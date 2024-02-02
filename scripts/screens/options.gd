extends Control

var _sound_btn_sound_on = load("res://art/sprites/ui/icone_son_plein.svg")
var _sound_btn_sound_off = load ("res://art/sprites/ui/icone_son_coupe.svg")
var _toggle_sound_on = true
var _toggle_music_on = true

# Called when the node enters the scene tree for the first time.
func _ready():
	var blue_lotto = randf_range(0.0,1.0)
	$Background.material.set_shader_parameter("blue",blue_lotto)
	$AnimationPlayer.play("spin_me_round_round")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_sound_button_pressed():
	if _toggle_sound_on:
		$OptionsContainer/SoundButton.texture_normal = _sound_btn_sound_off
		_toggle_sound_on = false
		GlobalProperties.sound_on = false
	else:
		$OptionsContainer/SoundButton.texture_normal = _sound_btn_sound_on
		_toggle_sound_on = true
		GlobalProperties.sound_on = true


func _on_music_button_pressed():
	if _toggle_music_on:
		$OptionsContainer/MusicButton.texture_normal = _sound_btn_sound_off
		_toggle_music_on = false
		GlobalProperties.music_on = false
	else:
		$OptionsContainer/MusicButton.texture_normal = _sound_btn_sound_on
		_toggle_music_on = true
		GlobalProperties.music_on = true

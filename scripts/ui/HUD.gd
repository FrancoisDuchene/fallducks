extends CanvasLayer

# Notifies 'Main' node that the button has been pressed
signal start_game

var state_machine_hearts : AnimationNodeStateMachinePlayback
var game_is_active: bool = false

func _input(event):
	if event.is_action_pressed("start_game"):
		start_the_game()

func _on_message_timer_timeout():
	$Message.hide()

func _on_start_button_pressed():
	state_machine_hearts.travel("reset_life")
	start_the_game()
	
func _ready():
	state_machine_hearts = $AnimationTreeHearts["parameters/playback"]
	state_machine_hearts.start("Full_health", true)

func start_the_game():
	if !game_is_active:
		state_machine_hearts.travel("reset_life")
		$StartButton.hide()
		game_is_active = true
		start_game.emit()

func handle_hearts(health: int, max_health: int):
	if (health >= max_health):
		state_machine_hearts.travel("reset_life", false)
	elif (health >= 3):
		state_machine_hearts.travel("four_2_three")
	elif (health >= 2):
		state_machine_hearts.travel("three_2_two")
	elif (health >= 1):
		state_machine_hearts.travel("two_2_one")
	else:
		state_machine_hearts.travel("one_2_zero")

func show_game_over():
	show_message("Game Over", true)
	# Wait until the MessageTimer has counted down
	await $MessageTimer.timeout

	$Message.text = "He has fallen :("
	$Message.show()

	await get_tree().create_timer(1.0).timeout
	
	$StartButton.show()
	game_is_active = false

func show_message(text, use_message_timer: bool):
	$Message.text = text
	$Message.show()
	if use_message_timer:
		$MessageTimer.start()

func update_score(score):
	$ScoreLabel.text = "%d m" % score
	
func display_eagle_alert():
	$EagleAlert.play("default")
	
func hide_eagle_alert():
	$EagleAlert.stop()
	
func _on_pause_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

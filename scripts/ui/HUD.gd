extends CanvasLayer

# Notifies 'Main' node that the button has been pressed
signal start_game

var game_is_active: bool = false

func _input(event):
	if event.is_action_pressed("start_game"):
		start_the_game()

func _on_message_timer_timeout():
	$Message.hide()

func _on_start_button_pressed():
	start_the_game()

func _process(delta):
	pass

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

func start_the_game():
	if !game_is_active:
		$StartButton.hide()
		game_is_active = true
		start_game.emit()

func update_score(score):
	$ScoreLabel.text = str(score)


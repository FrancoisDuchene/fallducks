extends Node2D

var posVector: Vector2 = Vector2(0, 0)

func fit_to_screen(screen_size: Vector2):
	position.x = screen_size.x / 2
	var y_proport = 0.18 * screen_size.y
	position.y = screen_size.y - y_proport

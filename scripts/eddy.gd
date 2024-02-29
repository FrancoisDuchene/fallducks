extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var _eddy_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play("default")

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	#$AnimatedSprite2D.play("default")

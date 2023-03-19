extends AnimatedSprite2D

@onready var shaker = $Shaker

func _on_belched(mouthpos, dir):
	Input.start_joy_vibration(0, 1, 1, 0.7)
	show()
	shaker.start()
	position = mouthpos
	play()

func _on_belch_end():
	Input.stop_joy_vibration(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animation_finished() -> void:
	shaker.stop()
	stop()

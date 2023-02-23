extends AnimatedSprite2D

func _ready() -> void:
	Events.belched.connect(_on_belched)

func _on_belched(mouthpos, dir):
	Input.start_joy_vibration(0, 1, 1, 0.7)
	show()
	#print ("SHAKE START")
	position = mouthpos
	if dir == -1:
		flip_h = true
	else:
		flip_h = false
	play()

func _on_belch_end():
	Input.stop_joy_vibration(1)

func _on_animation_finished() -> void:
	#print ("finished")
	stop()

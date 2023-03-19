@tool
extends State

func _on_update(_delta: float) -> void:
	target.dir = Input.get_axis("in_left_analog", "in_right_analog")
	if target.dir == 0:
		target.dir = Input.get_axis("in_left", "in_right")
	elif target.dir < 0.1:
		target.dir = -1
	elif target.dir > 0.1:
		target.dir = 1
	
	if target.enable_physics:
		target.velocity.y += _delta * target.gravity

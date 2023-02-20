@tool
extends State

@export var speed : float = 300.0
var direction : float

func _on_update(_delta: float) -> void:
	direction = Input.get_axis("in_left_analog", "in_right_analog")
	
	if direction == 0:
		direction = Input.get_axis("in_left", "in_right")
	elif direction < 0.1:
		direction = -1
	elif direction > 0.1:
		direction = 1

	# Lets the player move if cutscene isnt active
	if direction and !Global.cutscene_active:
		target.velocity.x = direction * speed
		change_state("Walk")
	else:
		target.velocity.x = move_toward(target.velocity.x, 0, speed)

	target.move_and_slide()

func _after_update(_delta: float) -> void:
	target.move_and_slide()

	if target.velocity.x > 0:
		target.skin.scale.x = 1
	elif target.velocity.x < 0:
		target.skin.scale.x = -1

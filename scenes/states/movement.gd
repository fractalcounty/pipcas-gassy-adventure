@tool
extends State

@export var speed : float = 300.0


# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	pass


# This function is called just after the state enters
# XSM after_enters the children first, then the parent
func _after_enter(_args) -> void:
	pass


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	
	var direction := Input.get_axis("in_left", "in_right")
	if direction and !Global.is_cutscene_active: # Turns of user input
		target.velocity.x = direction * speed
		change_state("Walk")
	else:
		target.velocity.x = move_toward(target.velocity.x, 0, speed)

	target.move_and_slide()


# This function is called each frame after all the update calls
# XSM after_updates the children first, then the root
func _after_update(_delta: float) -> void:
	target.move_and_slide()

	if target.velocity.x > 0:
		target.skin.scale.x = 1
	elif target.velocity.x < 0:
		target.skin.scale.x = -1


# This function is called before the State exits
# XSM before_exits the root first, then the children
func _before_exit(_args) -> void:
	pass


# This function is called when the State exits
# XSM before_exits the children first, then the root
func _on_exit(_args) -> void:
	pass


# when StateAutomaticTimer timeout()
func _state_timeout() -> void:
	pass


# Called when any other Timer times out
func _on_timeout(_name) -> void:
	pass


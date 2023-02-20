@tool
extends State


#
# FUNCTIONS TO INHERIT IN YOUR STATES
#

# This function is called when the state enters
# XSM enters the root first, the the children
func _on_enter(_args) -> void:
	Global.mouse_moving = false
	var mixed_pos = target.pipca.global_position + target.global_offset
	var cam_pos : Vector2 = lerp(target.pipca.global_position, mixed_pos, 0.7)
	var subpixel_position = cam_pos.round() - cam_pos
	Global.viewport_container.material.set_shader_parameter("cam_offset", subpixel_position)
	target.global_position = target.actual_cam_pos.round()


# This function is called just after the state enters
# XSM after_enters the children first, then the parent


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	pass


# This function is called each frame after all the update calls
# XSM after_updates the children first, then the root
func _after_update(_delta: float) -> void:
	pass


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


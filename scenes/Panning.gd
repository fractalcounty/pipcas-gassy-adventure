@tool
extends State

var mouse_start : Vector2 = Vector2.ZERO

func _on_enter(_args) -> void:
	pass

# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)
	mouse_start = Global.viewport.get_mouse_position()
	
	
	target.window_size = DisplayServer.window_get_size()
	target.window_scale = (target.window_size / target.game_size).x

	#var timer
	#await get_tree().create_timer(1.0).timeout

	if Global.joy_moving:
		var movedir = Vector2.ZERO
		movedir.x = Input.get_action_strength("joy_right") - Input.get_action_strength("joy_left")
		movedir.y = Input.get_action_strength("joy_down") - Input.get_action_strength("joy_up")
		var multiplier = 100
		var mixed_pos = ((multiplier * movedir) + target.pipca.global_position) + target.global_offset + target.base_offset
		var cam_pos : Vector2 = lerp(target.pipca.global_position, mixed_pos, 0.7)
		target.actual_cam_pos = target.actual_cam_pos.lerp(cam_pos, _delta*5)
		var subpixel_position = target.actual_cam_pos.round() - target.actual_cam_pos
		Global.viewport_container.material.set_shader_parameter("cam_offset", subpixel_position)
		target.global_position = target.actual_cam_pos.round()
		#print(mixed_pos)
	
	if Global.mouse_moving:
		var mouse_pos = get_parent().raw_mouse_pos / target.window_scale - (target.game_size / 6)
		var mixed_pos = mouse_pos + target.pipca.global_position + target.global_offset + target.base_offset
		var cam_pos : Vector2 = lerp(target.pipca.global_position, mixed_pos, 0.7)
		target.actual_cam_pos = target.actual_cam_pos.lerp(cam_pos, _delta*5)
		var subpixel_position = target.actual_cam_pos.round() - target.actual_cam_pos
		Global.viewport_container.material.set_shader_parameter("cam_offset", subpixel_position)
		target.global_position = target.actual_cam_pos.round()


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
	print ("timeout")
	Global.mouse_moving = false
	get_parent().raw_mouse_pos = Vector2.ZERO


# Called when any other Timer times out
func _on_timeout(_name) -> void:
	pass


@tool
extends State

var mouse_start : Vector2 = Vector2.ZERO

func _on_enter(_args) -> void:
	pass

# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(delta: float) -> void:
	#mouse_start = Global.viewport.get_mouse_position()
	
	
	#target.window_size = DisplayServer.window_get_size()
	#target.window_scale = (target.window_size / target.game_size).x

#	if Global.joy_moving:
#		var movedir = Vector2.ZERO
#		movedir.x = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
#		movedir.y = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
#		var multiplier = 100
#		var mixed_pos = ((multiplier * movedir) + target.pipca.global_position) + target.global_offset + target.base_offset
#		var cam_pos : Vector2 = lerp(target.pipca.global_position, mixed_pos, target.joystick_lerp_weight)
#		target.actual_cam_pos = target.actual_cam_pos.lerp(cam_pos, _delta*target.joystick_lerp_multiplier)
#		var subpixel_position = target.actual_cam_pos.round() - target.actual_cam_pos
#		Global.viewport_container.material.set_shader_parameter("cam_offset", subpixel_position)
#		target.global_position = target.actual_cam_pos.round()
#		#print(mixed_pos)
		#var mouse_pos = get_parent().raw_mouse_pos / target.window_scale - (target.game_size / 6)
		
	#print (target.zoom_level)
	#var zoomer = 1
	#if target.zoom_level < 1:
		#zoomer = target.zoom_level
		
	
	
	# target.grounded_offset.y = -100 (Static)
	# new offset is -101?
	
	
	var zoom_mult : float = target.zoom_level * -10
	
	var zoom_fixed : float = -remap(zoom_mult, -6.5, -10, 145.0, 0.0)
	
	var added_offset : Vector2 = Vector2(0, (target.grounded_offset.y + zoom_fixed))
	var final_offset : Vector2 = target.grounded_offset + added_offset
	
	
	
	var mixed_pos = target.pipca.global_position + added_offset
	
	#print (mixed_pos)
	
	var cam_pos : Vector2 = lerp(target.pipca.global_position, mixed_pos, target.grounded_lerp_weight)
	target.actual_cam_pos = target.actual_cam_pos.lerp(cam_pos, delta*target.grounded_lerp_multiplier)
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
	Global.mouse_moving = false
	get_parent().raw_mouse_pos = Vector2.ZERO


# Called when any other Timer times out
func _on_timeout(_name) -> void:
	pass


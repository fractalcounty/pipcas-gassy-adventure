@tool
extends State

#var new_focus

#func _on_ready(_args) -> void:
	#Events.cutscene_start.connect(_on_cutscene_start)

#func _on_cutscene_start(focus) -> void:
	#new_focus = focus

func _on_update(_delta: float) -> void:
	pass
	Global.mouse_moving = false
	var mixed_pos = Global.focus.global_position + target.global_offset
	var cam_pos : Vector2 = lerp(Global.focus.global_position, mixed_pos, 0.5)
	target.actual_cam_pos = target.actual_cam_pos.lerp(cam_pos, _delta*0.5)
	var subpixel_position = target.actual_cam_pos.round() - target.actual_cam_pos
	Global.viewport_container.material.set_shader_parameter("cam_offset", subpixel_position)
	target.global_position = target.actual_cam_pos.round()

# when StateAutomaticTimer timeout()
func _state_timeout() -> void:
	change_state("Gameplay")

# Called when any other Timer times out
func _on_timeout(_name) -> void:
	change_state("Gameplay")

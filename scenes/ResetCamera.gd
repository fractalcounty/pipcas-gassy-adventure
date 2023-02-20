@tool
extends State

func _on_update(_delta: float) -> void:
	pass
	Global.mouse_moving = false
	var mixed_pos = Global.focus.global_position + target.global_offset + target.base_offset
	var cam_pos : Vector2 = lerp(Global.focus.global_position, mixed_pos, 0.5)
	target.actual_cam_pos = target.actual_cam_pos.lerp(cam_pos, _delta*0.5)
	var subpixel_position = target.actual_cam_pos.round() - target.actual_cam_pos
	Global.viewport_container.material.set_shader_parameter("cam_offset", subpixel_position)
	target.global_position = target.actual_cam_pos.round()


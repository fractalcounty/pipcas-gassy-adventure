@tool
extends State

func _on_update(_delta: float) -> void:
	var mouse_pos = (target.game_size / 24)
	var mixed_pos = target.pipca.global_position + target.global_offset + target.base_offset
	var cam_pos : Vector2 = lerp(target.pipca.global_position, mixed_pos, 0.7)
	target.actual_cam_pos = target.actual_cam_pos.lerp(cam_pos, _delta*5)
	var subpixel_position = target.actual_cam_pos.round() - target.actual_cam_pos
	Global.viewport_container.material.set_shader_parameter("cam_offset", subpixel_position)
	target.global_position = target.actual_cam_pos.round()

@tool
extends State

var cooldown : bool = false

func _on_enter(_args) -> void:
	cooldown = false

func _on_update(delta: float) -> void:
#	var mouse_pos = (target.game_size / 24)
#	var mixed_pos = target.pipca.global_position + target.global_offset + target.base_offset
#	var cam_pos : Vector2 = lerp(target.pipca.global_position, mixed_pos, target.still_camera_lerp_weight)
#	target.actual_cam_pos = target.actual_cam_pos.lerp(cam_pos, _delta*target.still_camera_lerp_multiplier)
#	var subpixel_position = target.actual_cam_pos.round() - target.actual_cam_pos
#	Global.viewport_container.material.set_shader_parameter("cam_offset", subpixel_position)
#	target.global_position = target.actual_cam_pos.round()
		
	var mixed_pos = target.pipca.global_position + target.air_offset
	var cam_pos : Vector2 = lerp(target.pipca.global_position, mixed_pos, target.air_lerp_weight)
	target.actual_cam_pos = target.actual_cam_pos.lerp(cam_pos, delta*target.air_lerp_multiplier)
	var subpixel_position = target.actual_cam_pos.round() - target.actual_cam_pos
	Global.viewport_container.material.set_shader_parameter("cam_offset", subpixel_position)
	target.global_position = target.actual_cam_pos.round()


# when StateAutomaticTimer timeout()
func _state_timeout() -> void:
	cooldown = true


# Called when any other Timer times out
func _on_timeout(_name) -> void:
	cooldown = true

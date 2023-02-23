@tool
extends State

func _on_enter(_args):
	if target.is_on_floor():
		change_state("OnGround")

func _on_update(delta: float) -> void:
	
	if target.dir != 0:
		target.velocity.x = lerp(target.velocity.x, target.air_speed * target.dir, target.air_accel * delta)
	else:
		target.velocity.x = lerp(target.velocity.x,  0.0, target.air_friction * delta)
	
	if target.is_on_floor():
		change_state("OnGround")

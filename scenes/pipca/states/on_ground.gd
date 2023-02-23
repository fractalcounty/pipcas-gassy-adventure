@tool
extends State

func _on_enter(_args) -> void:
	if not target.is_on_floor():
		change_state("Fall")

func _on_update(_delta: float) -> void:
	if target.dir == 0:
		if abs(target.velocity.x) < target.walk_margin:
			target.velocity = Vector2.ZERO
			change_state_if("Idle", "Brake")
		else:
			change_state("Brake")
	
	else:
		change_state("Walk")
		target.velocity.x = lerp(target.velocity.x,
			target.ground_speed * target.dir,
			target.acceleration * _delta)
	
	if not target.is_on_floor():
		var _s1 = change_state("OnGround")
		var _s2 = change_state("Fall")
	
	else:
		target.rotation = lerp(target.rotation, 0.0, _delta*10)

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
	
	elif !Input.is_action_pressed("in_dash"):
		change_state("Walk")
		target.velocity.x = lerp(target.velocity.x,
			target.ground_speed * target.dir,
			target.acceleration * _delta)
		
	else: 
		if Global.counter.points != 0:
			change_state("Dash")
			target.velocity.x = lerp(target.velocity.x,
			target.dash_speed * target.dir,
			target.dash_acceleration*2 * _delta)
			Global.counter.points -= -1
	
	if not target.is_on_floor():
		var _s1 = change_state("OnGround")
		var _s2 = change_state("Fall")
	
	else:
		target.rotation = lerp(target.rotation, 0.0, _delta*10)

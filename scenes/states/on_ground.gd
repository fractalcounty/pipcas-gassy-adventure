@tool
extends State

@export var walk_margin := 20.0
@export var jump_velocity := -400.0

func _on_update(_delta: float) -> void:
	if !target.is_on_floor():
		change_state("InAir")
	
	if target.dir == 0:
		if abs(target.velocity.x) < walk_margin:
			change_state("Idle")
		else:
			change_state("Walk")

@tool
extends State

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _on_enter(_args):
	if target.is_on_floor():
		change_state("OnGround")

func _on_update(_delta: float) -> void:
	if target.is_on_floor():
		change_state("OnGround")
	else:
		target.velocity.y += gravity * _delta

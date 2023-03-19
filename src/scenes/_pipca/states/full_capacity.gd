@tool
extends State

func _on_update(_delta: float) -> void:
	if Input.is_action_just_released("in_release"):
		change_state("NotCharging")

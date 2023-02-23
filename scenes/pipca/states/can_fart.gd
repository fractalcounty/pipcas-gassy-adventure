@tool
extends State

func _on_update(_delta) -> void:
	if Input.is_action_just_pressed("in_release"):
		change_state("GroundFart")

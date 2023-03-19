@tool
extends State


signal pre_farted


func _on_update(_delta) -> void:
	if Input.is_action_just_pressed("in_release"):
		emit_signal("pre_farted")

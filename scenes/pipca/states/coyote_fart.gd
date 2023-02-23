@tool
extends State

var origin_state

func _on_enter(from) -> void:
	origin_state = from

func _on_update(_delta) -> void:
	if Input.is_action_just_pressed("in_release"):
		if origin_state == "OnGround":
			var _st1 = change_state("GroundFart")
		var _st3 = change_state("CanPreFart")

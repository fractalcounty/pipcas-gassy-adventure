@tool
extends StateAnimation

var mouthpos : Vector2
var dir : int

func _on_anim_finished(_name: String) -> void:
	change_state("Still")

#func _on_enter(_args) -> void:
	#var mouth = target.mouth
	#mouthpos = mouth.global_position
	#dir = target.skin.scale.x
	#Events.belched.emit(mouthpos, dir)

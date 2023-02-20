@tool
extends State

var focus_target : Node2D

func _on_enter(_args) -> void:
	change_state("Gameplay")
	Events.cutscene_end.connect(_on_cutscene_end)
	
func _on_cutscene_end() -> void:
	change_state("Reset")

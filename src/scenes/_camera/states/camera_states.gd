@tool
extends State

var mouse_start : Vector2
@onready var raw_mouse_pos : Vector2
var focus_target : Node2D

#func _on_enter(_args) -> void:
	#Events.cutscene_end.connect(_on_cutscene_end)

func _on_update(_delta: float) -> void:
	raw_mouse_pos = Global.viewport.get_mouse_position()
	if Global.is_grounded:
		change_state("GroundCam")
	else:
		change_state("AirCam")




@tool
extends State

var mouse_start : Vector2
@onready var raw_mouse_pos : Vector2
var cutscene

func _on_enter(_args) -> void:
	change_state("Gameplay")
	Events.cutscene_start.connect(_on_cutscene_start)
	Events.cutscene_end.connect(_on_cutscene_end)

func _on_cutscene_start():
	cutscene = true
	#change_state("Cutscene")
	
func _on_cutscene_end():
	cutscene = false
	#change_state("Gameplay")

func _after_enter(_args) -> void:
	change_state("Still")

func _on_update(_delta: float) -> void:
	raw_mouse_pos = Global.viewport.get_mouse_position()
	if !cutscene:
		if Global.mouse_moving or Global.joy_moving:
			change_state("Panning")
		else:
			change_state("Still")
	else:
		change_state("Locked")

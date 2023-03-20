extends AnimationPlayer

@export var cutscene : Resource
@export var focus : Node2D
@export var player : CharacterBody2D

func _on_ready():
	Global.focus = player

func _on_cutscene_1_body_entered(body: Node2D) -> void:
	Global.game_state = Global.state.CUTSCENE
	play("test_cutscene")
	Events.cutscene_start.emit()
	Global.focus = focus
	Global.cutscene_active = true

func _on_cutscene_end() -> void:
	Global.game_state = Global.state.GAME
	Events.cutscene_end.emit()
	Global.cutscene_active = false
	queue_free()
	
func set_pipca_focus() -> void:
	Global.focus = player

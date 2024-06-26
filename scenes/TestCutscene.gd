extends Node2D

@export var cutscene : Resource
@export var anim : AnimationPlayer

func _on_cutscene_trigger(body: Node2D) -> void:
	Events.cutscene_start.emit(cutscene)
	anim.play("test_cutscene")

func _on_cutscene_end() -> void:
	Events.cutscene_end.emit()

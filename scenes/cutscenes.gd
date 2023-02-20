extends AnimationPlayer

@export var cutscene : Resource
@export var focus : Node2D
@export var pipca : Pipca

func _on_ready():
	Global.focus = pipca

func _on_cutscene_1_body_entered(body: Node2D) -> void:
	play("test_cutscene")
	Events.cutscene_start.emit()
	Global.focus = focus
	Global.is_cutscene_active = true

func _on_reset_state_exited(sender) -> void:
	print("RESET CAM")

func _on_cutscene_end() -> void:
	Events.cutscene_end.emit()
	Global.is_cutscene_active = false
	
func set_pipca_focus() -> void:
	Global.focus = pipca

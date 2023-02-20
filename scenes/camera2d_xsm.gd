@tool
extends State

var focus_target : Node2D

func _on_enter(_args) -> void:
	change_state("Gameplay")
	Events.cutscene_start.connect(_on_cutscene_start)
	Events.cutscene_end.connect(_on_cutscene_end)

func _on_cutscene_start() -> void:
	change_state("Cutscene")
	
func _on_cutscene_end() -> void:
	change_state("Reset")

func _on_regain_control() -> void:
	change_state("Gameplay")

# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	pass


# This function is called each frame after all the update calls
# XSM after_updates the children first, then the root
func _after_update(_delta: float) -> void:
	pass


# This function is called before the State exits
# XSM before_exits the root first, then the children
func _before_exit(_args) -> void:
	pass


# This function is called when the State exits
# XSM before_exits the children first, then the root
func _on_exit(_args) -> void:
	pass


# when StateAutomaticTimer timeout()
func _state_timeout() -> void:
	pass


# Called when any other Timer times out
func _on_timeout(_name) -> void:
	pass


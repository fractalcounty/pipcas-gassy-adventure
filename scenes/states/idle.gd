@tool
extends State

@export var idle_timer : float = 1.0
@export var blink_chance : float = 0.75
@export var belch_chance : float = 0.1

func _on_enter(_args) -> void:
	add_timer("Idle", idle_timer)

func _on_update(_delta: float) -> void:
	if Input.is_action_just_pressed("in_belch"):
		change_state("Belch")
	if !target.dir == 0:
		del_timers()
		change_state("Walk")

func _on_timeout(_idle) -> void:
	if !is_active("Walk"):
		var percent = randf()
		if (percent < blink_chance):
			change_state("Blink")
		if (percent < belch_chance):
			change_state("Belch")
		add_timer("Idle", idle_timer)

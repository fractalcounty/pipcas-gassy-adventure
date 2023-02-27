@tool
extends StateAnimation

@onready var pulse_freq : float = 0.001
@onready var pulse_phase : float = -1.527

var clamped_time : float = 0.0

func _on_enter(_args) -> void:
	target.original_mouse_pos = target.current_mouse_pos
	target.fart_charge = 0
	target.charging_shaker.start()
	target.look.pulling = true

func _after_update(delta: float) -> void:
	if Input.is_action_just_released("in_charge"):
		release(delta)


func release(delta: float) -> void:
		change_state("GroundFart")
		change_state("CanCharge")
		target.look.pulling = false

func _on_exit(_args) -> void:
	target.charging_shaker.stop()

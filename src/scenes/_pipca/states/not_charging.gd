@tool
extends State

var cooldown : bool = false

@onready var pulse_freq : float = 0.001
@onready var pulse_phase : float = -1.527

func _on_enter(_args) -> void:
	change_state("NoFart")


# This function is called each frame if the state is ACTIVE
# XSM updates the root first, then the children
func _on_update(_delta: float) -> void:
	if cooldown:
		if Input.is_action_pressed("in_charge"):
			target.charge_meter = 0.0
			change_state("Charging")
		else:
			change_state("NotCharging")
	else:
		change_state("NotCharging")

# This function is called each frame after all the update calls
# XSM after_updates the children first, then the root
func _after_update(_delta: float) -> void:
	pass


# This function is called when the State exits
# XSM before_exits the children first, then the root
func _on_exit(_args) -> void:
	cooldown = false


# when StateAutomaticTimer timeout()
func _state_timeout() -> void:
	cooldown = true


# Called when any other Timer times out
func _on_timeout(_name) -> void:
	cooldown = true


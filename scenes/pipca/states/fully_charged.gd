@tool
extends State

var time : float = 0

func _on_enter(_args) -> void:
	target.shaker.start()
	change_state("CanFart")
	target.charge_meter = 0.0
	time = 0

func _on_update(delta: float) -> void:
	time += delta
	target.charge_meter = clampf(time, 0.0, target.fart_max_charge_time)
	
	#print (target.charge_meter)
	if Input.is_action_just_released("in_charge"):
		time = 0
		target.charge_meter = 0.0
		change_state("NotCharging")
	if Input.is_action_just_pressed("in_release"):
		time = 0.0
		change_state("NotCharging")
		


# This function is called each frame after all the update calls
# XSM after_updates the children first, then the root
func _after_update(_delta: float) -> void:
	pass


# This function is called before the State exits
# XSM before_exits the root first, then the children
func _before_exit(_args) -> void:
	time = 0
	target.shaker.stop()


# This function is called when the State exits
# XSM before_exits the children first, then the root
func _on_exit(_args) -> void:
	time = 0


# when StateAutomaticTimer timeout()
func _state_timeout() -> void:
	pass


# Called when any other Timer times out
func _on_timeout(_name) -> void:
	pass


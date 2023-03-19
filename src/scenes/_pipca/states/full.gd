@tool
extends State

#var tween : Tween

func _on_enter(_args) -> void:
	target.charged_shaker.start()

func _on_update(delta: float) -> void:
#	tween = create_tween()
#	my_tween_loop()
	if Input.is_action_just_released("in_charge"):
		target.charge_meter = 0.0
		change_state("GroundFart")
		change_state("CanCharge")

#func my_tween_loop() -> void:
#	tween.set_parallel(true)
#	tween.tween_property(target.skin, "material:shader_parameter/pulse_frequency", target.charge_meter*5, 0.3)
#	tween.set_ease(Tween.EASE_IN)
#	tween.set_trans(Tween.TRANS_SINE)

func _on_exit(_args) -> void:
	target.charged_shaker.stop()

#func _before_exit(_args) -> void:
#	if tween:
#		tween.kill() # Abort the previous animation.

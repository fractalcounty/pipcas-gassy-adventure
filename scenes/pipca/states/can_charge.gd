@tool
extends StateAnimation

#var tween : Tween

@onready var pulse_freq : float = 0.001
@onready var pulse_phase : float = -1.527

func _on_enter(_args) -> void:
	pass

#func _after_enter(_args) -> void:
	#target.skin.material.set_shader_parameter("shader_parameter/pulse_frequency", 0)
	#target.skin.material.set_shader_parameter("shader_parameter/pulse_phase", -1.527)

func _on_update(_delta: float) -> void:
	#target.skin.material.set_shader_parameter("shader_parameter/pulse_frequency", 0)
	#target.skin.material.set_shader_parameter("shader_parameter/pulse_phase", -1.527)

	if Input.is_action_just_pressed("in_charge"):
		change_state("Charging")
	
#	tween = create_tween()
#	tween.set_parallel(true)
#	tween.tween_property(target.skin, "material:shader_parameter/pulse_frequency", pulse_freq, 0.09)
#	tween.set_ease(Tween.EASE_IN_OUT)
#	tween.set_trans(Tween.TRANS_CUBIC)

#func _before_exit(_args) -> void:
#	if tween:
#		tween.kill()

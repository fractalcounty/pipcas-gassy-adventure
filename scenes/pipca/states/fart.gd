@tool
extends State

var entering_y := 0.0

func _on_enter(_args) -> void:
	target.emit_fart()
	change_state("NoFart")
	entering_y = target.position.y
	var fart_sound = target.fart_sounds
	fart_sound.play()
	fart_sound.pitch_scale = 1.0 + ( randf() - 0.5 ) / 3

func _on_update(delta) -> void:
	get_active_substate().fart(delta)

	if not Input.is_action_pressed("in_release"):
		if target.position.y < entering_y - target.fart_min_height:
			change_state("Fall")
	elif target.position.y < entering_y - target.fart_max_height:
		change_state("Fall")

	if target.velocity.x == 0 and target.dir != 0 and not target.is_on_wall():
		target.velocity = target.velocity.rotated(target.dir * PI/2)

func _on_fart_finished() -> void:
	get_active_substate().play("Fall")

#
#func _on_update(_delta: float) -> void:
#	if Input.is_action_just_pressed("in_charge"):
#		target.shaker.start()
#		print ("Charging...")
#		change_state("Charge")
#	if Input.is_action_just_released("in_charge"):
#		target.shaker.stop()
#		change_state("Release")
#		print ("Releasing...")

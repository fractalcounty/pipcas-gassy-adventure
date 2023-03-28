# move.gd
extends PlayerState

func enter(_msg := {}) -> void:
	if state_machine.last_state_was("fall") or state_machine.last_state_was("jump"):
			state_machine.animation_player.play("land2")
			state_machine.animation_player.queue("walk")
	else:
		state_machine.animation_player.play("walk")
	player.sound.step.pitch_scale = 1.0 + ( randf() - 0.5 ) / 3
	player.sound.step.play()
	player.emit_dust = true
	player.effects.stop_ghost_effect()
	
	player.crouch_collision.set_disabled(true)
	player.stand_collision.set_disabled(false)

func physics_update(_delta):
	
	if player.is_on_floor():
		if player.is_moving():
			player.do_horizontal_movement(_delta)
			play_step_sound(_delta, player.move_step_interval)

			if InputBuffer.is_action_press_buffered("jump"):
				state_machine.transition_to("jump")
			elif InputBuffer.is_action_press_buffered("dash"):
				state_machine.transition_to("suplex_dash")
			elif InputBuffer.is_action_press_buffered("down") or Input.is_action_pressed("down"):
				state_machine.transition_to("crouch")
			elif InputBuffer.is_action_press_buffered("taunt"):
				state_machine.transition_to("taunt")
		else:
			var deceleration_direction : float = -sign(player.velocity.x)
			player.velocity.x += player.deceleration * deceleration_direction * _delta
			if sign(player.velocity.x) != deceleration_direction:
				player.velocity.x = 0
				state_machine.transition_to("idle")
		player.velocity.y = 0
	else:
		state_machine.transition_to("fall")

	player.move_and_slide()

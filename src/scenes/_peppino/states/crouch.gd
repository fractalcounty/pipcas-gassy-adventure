# crouch.gd
extends PlayerState

func enter(_msg := {}) -> void:
	if not state_machine.last_state_was("crawl"):
		state_machine.animation_player.play("crouch_start")
		state_machine.animation_player.queue("crouch")
	else:
		state_machine.animation_player.play("crouch")
	player.emit_dust = false
	player.velocity = Vector2.ZERO
	player.crouch_collision.set_disabled(false)
	player.stand_collision.set_disabled(true)

func physics_update(_delta: float):
	
	if Input.is_action_pressed("down"):
		if player.is_moving():
			state_machine.transition_to("crawl")
		if InputBuffer.is_action_press_buffered("jump"):
			state_machine.transition_to("crouch_jump")
	else:
		state_machine.transition_to("idle")

	player.move_and_slide()

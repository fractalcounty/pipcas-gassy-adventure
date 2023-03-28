# crawl.gd
extends PlayerState

func enter(_msg := {}) -> void:
	if state_machine.last_state_was("crouch_jump") or state_machine.last_state_was("crouch_fall"):
		state_machine.animation_player.play("crouch_start")
		state_machine.animation_player.queue("crawl")
	else:
		state_machine.animation_player.play("crawl")
	player.sound.step.pitch_scale = 1.0 + ( randf() - 0.5 ) / 3
	player.sound.step.play()
	player.crouch_collision.set_disabled(false)
	player.stand_collision.set_disabled(true)


func physics_update(_delta):
	
	if Input.is_action_pressed("down") and player.is_moving():
		player.velocity.x = player.input.x * player.speed * player.crawl_speed_multiplier
		play_step_sound(_delta, player.crawl_step_interval)
		

		if InputBuffer.is_action_press_buffered("jump"):
			state_machine.transition_to("crouch_jump")
		
	else:
		state_machine.transition_to("crouch")
	
	player.move_and_slide()

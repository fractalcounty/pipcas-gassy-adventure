# fall.gd
extends PlayerState

var jump_params : Dictionary

func enter(_msg := {}) -> void:
	jump_params = get_jump_params("jump")

	if not state_machine.last_state_was("taunt"):
		state_machine.animation_player.queue("fall")
	else:
		state_machine.animation_player.play("fall")
	player.emit_dust = false
	
	player.crouch_collision.set_disabled(true)
	player.stand_collision.set_disabled(false)

func physics_update(_delta):

	if Input.is_action_just_pressed("taunt"):
		state_machine.transition_to("taunt")
	if InputBuffer.is_action_press_buffered("down"):
		state_machine.transition_to("body_slam_start")
	elif InputBuffer.is_action_press_buffered("dash"):
		state_machine.transition_to("suplex_grab_jump")
	
	if player.is_on_floor():
		player.effects.spawn_land_cloud()
		player.sound.step.pitch_scale = 1.0 + ( randf() - 0.5 ) / 3
		player.sound.step.play()
		if player.is_moving():
			state_machine.transition_to("move")
		else:
			state_machine.transition_to("idle")
	
	if player.is_moving():
		player.velocity.x += player.air_acceleration * player.input.x * _delta
		player.velocity.x = clamp(player.velocity.x, -player.max_speed, player.max_speed)
	else:
		player.velocity.x = 0
	
	player.velocity.y += get_gravity(jump_params) * _delta
	player.move_and_slide()

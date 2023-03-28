# suplex_dash.gd
extends PlayerState

var dash_dir : int

func enter(_msg := {}) -> void:
	dash_dir = -1 if player.sprite.flip_h else 1
	player.sound.dash.play()
	player.effects.start_ghost_effect(false, 0.08, 0.1)
	player.effects.spawn_dash_cloud()
	state_machine.animation_player.play("suplex_dash")
	player.velocity.x = player.dash_speed * dash_dir

func physics_update(_delta):
	
	if InputBuffer.is_action_press_buffered("jump"):
		state_machine.transition_to("long_jump")
	if InputBuffer.is_action_press_buffered("down"):
		state_machine.transition_to("crouch_slip")
	
	# Dash cancelling
	if player.is_moving(): 
		var move_input_direction : float = sign(player.input.x)
		if move_input_direction * dash_dir < 0: # Opposite direction input
			player.sprite.flip_h = move_input_direction < 0
			state_machine.transition_to("move")

	player.move_and_slide()

func anim_finished(_name : StringName) -> void:
	if _name == "suplex_dash":
		if player.is_moving():
			state_machine.transition_to("move")
		else:
			state_machine.transition_to("idle")
			player.sprite.offset = Vector2(0, -46)

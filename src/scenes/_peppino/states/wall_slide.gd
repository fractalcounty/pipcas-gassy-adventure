# wall_slide.gd
extends PlayerState

func enter(_msg := {}) -> void:
	
	state_machine.animation_player.play("wall_slide")
	player.sound.slide_ground.play()
	
	
func physics_update(_delta):
	player.sprite.offset.x = 0 if player.sprite.scale.x == -1 else 100
	var jump_params : Dictionary = get_jump_params("jump")
	player.velocity.y += get_gravity(jump_params) * _delta
	
	if player.is_on_wall() and not player.is_on_floor():
		# Slow down the vertical sliding speed
		player.velocity.y = min(player.velocity.y, 100) # Adjust this value to control the sliding speed
		
		#if InputBuffer.is_action_press_buffered("jump"):
			#state_machine.transition_to("wall_jump")
	else:
		# If the player is no longer touching the wall or is on the floor, transition to the appropriate state
		if player.is_on_floor():
			state_machine.transition_to("idle")
		else:
			state_machine.transition_to("fall")
		
	player.move_and_slide()

func exit() -> void:
	player.sound.slide_ground.stop()

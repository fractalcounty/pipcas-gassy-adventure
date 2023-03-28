# crouch_slip.gd
extends PlayerState

func enter(_msg := {}) -> void:
	state_machine.animation_player.play("mach_roll")
	player.crouch_collision.set_disabled(false)
	player.stand_collision.set_disabled(true)

func physics_update(_delta):
	
	if Input.is_action_pressed("down"):
		player.move_and_slide()
	else:
		state_machine.transition_to("long_jump_slide")

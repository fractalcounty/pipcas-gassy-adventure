# long_jump_slide.gd
extends PlayerState

func enter(_msg := {}) -> void:
	player.effects.stop_ghost_effect()
	player.sound.mach_slide_boost.play()
	state_machine.animation_player.play("mach_slide")

func physics_update(_delta):
	player.velocity.x *= 0.93 # Deceleration factor
	
	if abs(player.velocity.x) < 15.0:
		state_machine.transition_to("idle", {"status": "winding"})

	player.move_and_slide()

# suplex_grab_jump.gd
extends PlayerState

func enter(_msg := {}) -> void:
	
	state_machine.animation_player.play("wall_splat")
	player.sound.wall_splat.play()
	player.effects.stop_ghost_effect()
	player.crouch_collision.set_disabled(false)
	player.stand_collision.set_disabled(true)
	player.velocity = Vector2(0, 0)
	
func physics_update(_delta):
	pass

func anim_finished(_name : StringName) -> void:
	if _name == "wall_splat":
		state_machine.transition_to("idle")

# crouch_fall.gd
extends PlayerState

# Jump/fall physics
var crouch_jump_velocity : float
var crouch_jump_gravity : float
var crouch_fall_gravity : float

func enter(_msg := {}) -> void:
	crouch_jump_velocity = ((2.0 * player.crouch_jump_height) / player.crouch_jump_time_to_peak) * -1.0
	crouch_jump_gravity = ((-2.0 * player.crouch_jump_height) / (player.crouch_jump_time_to_peak * player.crouch_jump_time_to_peak)) * -1.0
	crouch_fall_gravity = ((-2.0 * player.crouch_jump_height) / (player.crouch_jump_time_to_descent * player.crouch_jump_time_to_descent)) * -1.0
	
	state_machine.animation_player.queue("crouch_fall")
	player.crouch_collision.set_disabled(false)
	player.stand_collision.set_disabled(true)

func physics_update(_delta):
	if player.is_on_floor():
		player.sound.step.pitch_scale = 1.0 + ( randf() - 0.5 ) / 3
		player.sound.step.play()
		
		state_machine.transition_to("crouch")

	elif player.is_moving():
		player.do_horizontal_movement(_delta)
	else:
		player.velocity.x = 0
	
	player.velocity.y += _get_crouch_jump_gravity() * _delta
	player.move_and_slide()

func _get_crouch_jump_gravity() -> float:
	return crouch_jump_gravity if player.velocity.y < 0.0 else crouch_fall_gravity

# long_jump.gd
extends PlayerState

var jump_dir : int
var ended : bool = false

## Long jump physics
var long_jump_velocity : float
var long_jump_gravity : float
var long_jump_fall_gravity : float

func enter(_msg := {}) -> void:
	
	long_jump_velocity = ((2.0 * player.long_jump_height) / player.long_jump_time_to_peak) * -1.0
	long_jump_gravity = ((-2.0 * player.long_jump_height) / (player.long_jump_time_to_peak * player.long_jump_time_to_peak)) * -1.0
	long_jump_fall_gravity = ((-2.0 * player.long_jump_height) / (player.long_jump_time_to_descent * player.long_jump_time_to_descent)) * -1.0
	
	ended = false
	jump_dir = -1 if player.sprite.flip_h else 1
	player.sound.roll_get_up.play()
	player.effects.start_ghost_effect(true, 0.1, 0.3)
#	player.effects.spawn_dash_cloud()
	state_machine.animation_player.play("long_jump")
#	player.velocity.x = player.dash_speed * dash_dir
#
func physics_update(_delta):
	
	if player.is_on_floor():
		if not ended:
			player.velocity.y = long_jump_velocity
		else:
			state_machine.transition_to("long_jump_slide")
	elif InputBuffer.is_action_press_buffered("dash"):
		state_machine.transition_to("suplex_grab_jump")
	elif InputBuffer.is_action_press_buffered("down"):
		state_machine.transition_to("dive")
	
	player.velocity.y += _get_long_jump_gravity() * _delta
	player.move_and_slide()

func anim_finished(_name : StringName) -> void:
	if _name == "long_jump":
		ended = true
		state_machine.animation_player.play("long_jump_end")
		#player.sprite.offset = Vector2(0, -46)

func _get_long_jump_gravity() -> float:
	return long_jump_gravity if player.velocity.y < 0.0 else long_jump_fall_gravity

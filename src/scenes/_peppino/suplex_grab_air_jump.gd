# suplex_grab_air_jump.gd
extends PlayerState

var dash_dir : int
var dash_speed : float = 800 # Modify this value to change the dash speed

# Jump physics
var grab_air_jump_velocity : float
var grab_air_jump_gravity : float
var grab_air_jump_fall_gravity : float

func enter(_msg := {}) -> void:
	
	grab_air_jump_velocity = ((2.0 * player.grab_air_jump_height) / player.grab_air_jump_time_to_peak) * -1.0
	grab_air_jump_gravity = ((-2.0 * player.grab_air_jump_height) / (player.grab_air_jump_time_to_peak * player.grab_air_jump_time_to_peak)) * -1.0
	grab_air_jump_fall_gravity = ((-2.0 * player.grab_air_jump_height) / (player.grab_air_jump_time_to_descent * player.grab_air_jump_time_to_descent)) * -1.0
	
	state_machine.animation_player.play("suplex_grab_jump_start")
	player.sound.dash.play()
	player.effects.start_ghost_effect(false, 0.08, 0.1)
	
	# Set the player's horizontal velocity
	dash_dir = 1 if not player.sprite.flip_h else -1
	player.velocity.x = dash_speed * dash_dir
	
func physics_update(_delta):
	
	# Apply gravity to the player's vertical velocity
	player.velocity.y += _get_grab_air_jump_gravity() * _delta
	player.velocity.x = dash_speed * dash_dir
	
	if player.is_on_floor():
		if InputBuffer.is_action_press_buffered("jump"):
			state_machine.transition_to("LongJump")
		else:
			state_machine.transition_to("idle")
	else:
		player.move_and_slide()

func anim_finished(_name : StringName) -> void:
	if _name == "suplex_dash_jump_start":
		state_machine.animation_player.play("suplex_grab_jump")
		player.effects.stop_ghost_effect()

func _get_grab_air_jump_gravity() -> float:
	return grab_air_jump_gravity if player.velocity.y < 0.0 else grab_air_jump_fall_gravity

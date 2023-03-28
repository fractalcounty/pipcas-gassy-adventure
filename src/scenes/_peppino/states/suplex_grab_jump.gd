# suplex_grab_jump.gd
extends PlayerState

var dash_dir : int
var dash_speed : float = 800
var ended : bool = false

# Jump physics
var grab_jump_velocity : float
var grab_jump_gravity : float
var grab_jump_fall_gravity : float

func enter(_msg := {}) -> void:
	
	grab_jump_velocity = ((2.0 * player.grab_jump_height) / player.grab_jump_time_to_peak) * -1.0
	grab_jump_gravity = ((-2.0 * player.grab_jump_height) / (player.grab_jump_time_to_peak * player.grab_jump_time_to_peak)) * -1.0
	grab_jump_fall_gravity = ((-2.0 * player.grab_jump_height) / (player.grab_jump_time_to_descent * player.grab_jump_time_to_descent)) * -1.0
	
	ended = false
	state_machine.animation_player.play("suplex_grab_jump_start")
	player.sound.dash.play()
	player.effects.start_ghost_effect(false, 0.08, 0.1)
	
	dash_dir = 1 if not player.sprite.flip_h else -1
	player.velocity.x = dash_speed * dash_dir
	
func physics_update(_delta):
	
	# Apply gravity to the player's vertical velocity
	player.velocity.y += _get_grab_jump_gravity() * _delta
	player.velocity.x = dash_speed * dash_dir
	
	if player.is_on_floor():
		if InputBuffer.is_action_press_buffered("jump"):
			state_machine.transition_to("long_jump")
		else:
			state_machine.transition_to("idle")
	else:
		player.move_and_slide()

func anim_finished(_name : StringName) -> void:
	if _name == "suplex_grab_jump_start":
		print("playing anim")
		state_machine.animation_player.play("suplex_grab_jump")

func _get_grab_jump_gravity() -> float:
	return grab_jump_gravity if player.velocity.y < 0.0 else grab_jump_fall_gravity

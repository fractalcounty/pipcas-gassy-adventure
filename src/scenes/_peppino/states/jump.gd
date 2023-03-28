# jump.gd
extends PlayerState

var crouch_jump_hold_timer : float = 0.0
var jump_animation_finished: bool = false
var jump_params : Dictionary

func enter(_msg := {}) -> void:
	jump_params = get_jump_params()

	player.effects.spawn_jump_cloud()
	state_machine.animation_player.play("jump")
	player.sound.jump.pitch_scale = 1.0 + ( randf() - 0.5 ) / 3
	player.sound.jump.play()
	player.emit_dust = false

func physics_update(_delta):
	
	if player.velocity.y > 0.0:
		state_machine.transition_to("fall")
	
	if player.is_on_floor():
			player.velocity.y = jump_params["jump_velocity"]
	elif player.is_on_wall():
		state_machine.transition_to("wall_slide")
	
	elif InputBuffer.is_action_press_buffered("down"):
		player.velocity.y = 0.0
		state_machine.transition_to("body_slam_start")
	elif InputBuffer.is_action_press_buffered("dash"):
		state_machine.transition_to("suplex_grab_jump")
	elif InputBuffer.is_action_press_buffered("taunt"):
		state_machine.transition_to("taunt")
	
	if player.is_moving():
		player.do_horizontal_movement(_delta)
	else:
		player.velocity.x = 0
	
	player.velocity.y += get_gravity(jump_params) * _delta
	player.move_and_slide()

func anim_finished(_name : StringName) -> void:
	if _name == "jump":
		player.effects.spawn_land_cloud()
		state_machine.transition_to("idle")

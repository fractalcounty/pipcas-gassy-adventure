# body_slam_start.gd
extends PlayerState

var jump_params : Dictionary

func enter(_msg := {}) -> void:
	jump_params = get_jump_params("body_slam")
	
	state_machine.animation_player.play("body_slam_start")
	player.sound.body_slam_start.play()
	player.effects.start_ghost_effect(false, 0.08, 0.1)
	
	player.velocity.y += jump_params["jump_velocity"]

func physics_update(_delta):
	if player.is_on_floor():
		state_machine.transition_to("body_slam_land")
	
	player.velocity.y += get_gravity(jump_params) * _delta
	player.move_and_slide()

func anim_finished(_name : StringName) -> void:
	if _name == "body_slam_start":
		player.sound.body_slam_start.stop()
		state_machine.transition_to("body_slam_fall")

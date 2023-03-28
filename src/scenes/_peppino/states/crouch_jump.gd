# taunt.gd
extends PlayerState

var jump_params : Dictionary

func enter(_msg := {}) -> void:
	jump_params = get_jump_params()
	
	if state_machine.last_state_was("crawl"):
		state_machine.animation_player.stop()
		state_machine.animation_player.play("crouch_jump")
	else:
		state_machine.animation_player.play("crouch_jump")
	
	player.sound.jump.pitch_scale = 1.0 + ( randf() - 0.5 ) / 3
	player.sound.jump.play()
	player.crouch_collision.set_disabled(false)
	player.stand_collision.set_disabled(true)

func physics_update(_delta):
	
	if player.is_on_floor():
		player.velocity.y = jump_params["jump_velocity"]

	if player.is_moving():
		player.do_horizontal_movement(_delta)
	else:
		player.velocity.x = 0
	
	player.velocity.y += get_gravity(jump_params) * _delta
	player.move_and_slide()

func anim_finished(_name : StringName) -> void:
	print ("finished crouch jump")
	if _name == "crouch_jump":
		state_machine.transition_to("crouch_fall")

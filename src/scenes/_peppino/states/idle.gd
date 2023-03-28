# idle.gd
extends PlayerState

func enter(_msg := {}) -> void:
	player.velocity = Vector2.ZERO
	player.emit_dust = false
	player.effects.stop_ghost_effect()
	
	# Idle animation timer
	start_timer(randf_range(player.idle_random_interval.x, player.idle_random_interval.y))
	
	if state_machine.last_state_was("fall") or state_machine.last_state_was("crouch_fall"):
		state_machine.animation_player.play("land")
	elif "status" in _msg:
		if _msg["status"] == "hurt":
			state_machine.animation_player.play("idle_face_hurt_up")
			state_machine.animation_player.queue("idle_face_hurt")
		elif _msg["status"] == "winding":
			state_machine.animation_player.play("idle_winding")
	else:
		state_machine.animation_player.play("idle")
	
	player.crouch_collision.set_disabled(true)
	player.stand_collision.set_disabled(false)

func physics_update(_delta: float) -> void:
	
	if player.is_on_floor():
		if player.is_moving():
			state_machine.transition_to("move")
		elif InputBuffer.is_action_press_buffered("jump"):
			state_machine.transition_to("jump")
		elif InputBuffer.is_action_press_buffered("down") or Input.is_action_pressed("down"):
			state_machine.transition_to("crouch")
		elif InputBuffer.is_action_press_buffered("taunt"):
			state_machine.transition_to("taunt")
		elif InputBuffer.is_action_press_buffered("dash"):
			state_machine.transition_to("suplex_dash")
	else:
		state_machine.transition_to("fall")

	player.move_and_slide()

func anim_finished(_name : StringName) -> void:
	print (_name)
	if _name == "land":
		state_machine.animation_player.play("idle")
	if _name.begins_with("IdleRandoms/"):
		state_machine.animation_player.play("idle")

# Pick random idle animation
func on_timer_end() -> void:
	var animations : AnimationLibrary = state_machine.animation_player.get_animation_library("IdleRandoms")
	var animation_list : PackedStringArray = animations.get_animation_list()
	var random_animation : StringName = animation_list[randi() % animation_list.size()]
	var picked_animation : String = "IdleRandoms/" + str(random_animation)
	state_machine.animation_player.play(picked_animation)

	start_timer(randf_range(player.idle_random_interval.x, player.idle_random_interval.y))

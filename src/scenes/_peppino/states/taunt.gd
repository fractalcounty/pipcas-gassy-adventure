# taunt.gd
extends PlayerState

func enter(_msg := {}) -> void:
	start_timer(player.taunt_duration)
	
	player.input_enabled = false
	player.sound.taunt.pitch_scale = 1.0 + ( randf() - 0.3 ) / 3
	player.sound.taunt.play()
	
	if player.is_on_floor():
		player.velocity.x = 0

	var animations : AnimationLibrary = state_machine.animation_player.get_animation_library("TauntRandoms")
	var animation_list : PackedStringArray = animations.get_animation_list()
	var random_animation : StringName = animation_list[randi() % animation_list.size()]
	var picked_animation : String = "TauntRandoms/" + str(random_animation)
	state_machine.animation_player.play(picked_animation)

	player.effects.spawn_taunt_effect(1.0)

func physics_update(_delta: float) -> void:
	owner.velocity.y = 0

func exit() -> void:
	player.input_enabled = true
	player.effects.stop_taunt_effect()
	player.sprite.stop()

func on_timer_end():
	stop_timer()
	if player.is_on_floor():
		state_machine.transition_to("idle")
	else:
		state_machine.transition_to("fall")

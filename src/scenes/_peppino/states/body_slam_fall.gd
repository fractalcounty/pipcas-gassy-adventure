# body_slam_fall.gd
extends PlayerState

func enter(_msg := {}) -> void:
	player.sound.body_slam_loop.play()
	state_machine.animation_player.play("body_slam_fall")


func physics_update(_delta):

	if player.is_on_floor():
		player.sound.body_slam_loop.stop()
		state_machine.transition_to("body_slam_land")
	
	player.velocity.y += _delta + 100
	player.move_and_slide()

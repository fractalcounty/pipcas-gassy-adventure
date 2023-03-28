# body_slam_land.gd
extends PlayerState

func enter(_msg := {}) -> void:
	player.sound.body_slam_land.play()
	Global.camera.shake(0.3)
	state_machine.animation_player.play("body_slam_land")

func physics_update(_delta):
	player.velocity = Vector2(0, 0)
	player.move_and_slide()

func anim_finished(_name : StringName) -> void:
	if _name == "body_slam_land":
		player.effects.spawn_slam_impact()
		state_machine.transition_to("idle", {"status": "hurt"})

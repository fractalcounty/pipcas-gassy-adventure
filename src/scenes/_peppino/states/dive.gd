# crouch_slip.gd
extends PlayerState

var dive_speed := 1000 # Modify this value to change the dive speed
var dive_angle := 40 # 40-degree angle to the ground

func enter(_msg := {}) -> void:
	player.effects.start_ghost_effect(false, 0.08, 0.1)
	state_machine.animation_player.play("dive")
	var dive_dir := Vector2.RIGHT.rotated(deg_to_rad(dive_angle))
	if player.dir == "left": # Check if the character is facing left
		dive_dir.x = -dive_dir.x
	player.velocity = dive_speed * dive_dir

func physics_update(_delta):
	
	#dive at an angle to the ground
	player.move_and_slide()
	
	if player.is_on_floor():
		if Input.is_action_pressed("down"):
			state_machine.transition_to("mach_roll")
		else:
			state_machine.transition_to("long_jump_slide")

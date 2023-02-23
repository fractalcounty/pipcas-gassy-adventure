@tool
extends State

var lookdir := Vector2.ZERO

func _on_update(delta: float) -> void:
	
	#var reset := Vector2.ZERO
	lookdir = target.look.crosshair_final.global_transform.origin
	
	#var pos_new = lerp(reset, lookdir, delta * 100)
	
	target.angle = target.get_angle_to(lookdir)
	
	var smooth = lerp(0.0, target.angle, delta*target.fart_rotation_control)
	
	target.rotate(smooth) 

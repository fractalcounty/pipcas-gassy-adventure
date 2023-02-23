@tool
extends StateAnimation

func fart():
	pass
	#var force = target.ground_fart_speed
	#target.apply_central_impulse(force)
	
	#var rotation = target.skin.rotation
	#var vector : Vector2 = Vector2(0, 1).rotated(rotation)
	target.velocity.y = - target.ground_fart_speed
	
	#target.velocity.y = - target.ground_fart_speed * vector
	
	#if target.charge_meter == 0:
		#target.velocity = - target.ground_fart_speed
	#else:
		#target.velocity = - target.ground_fart_speed #* (target.charge_meter*target.meter_multiplier)
	
	#var mouse_position = target.get_global_mouse_position()
	#var angle = target.get_angle_to(mouse_position)
	#target.rotate(angle) 
	
	#var bottom = target.position.y + target.collision_shape.shape.get_support(Vector2.DOWN).y


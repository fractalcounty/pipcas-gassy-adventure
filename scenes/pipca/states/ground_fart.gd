@tool
extends StateAnimation

func fart(delta):
	pass
	
	var direction = (target.look.crosshair_final.global_position - target.global_position).normalized()
	
	var launchforce = (target.charge) + (target.ground_fart_speed)
	
	var launchvel = -direction * launchforce
	
	target.velocity = launchvel

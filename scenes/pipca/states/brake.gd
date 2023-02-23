@tool
extends State

func _on_update(_delta):
	target.velocity.x = lerp(target.velocity.x, 0.0, target.ground_friction * _delta)

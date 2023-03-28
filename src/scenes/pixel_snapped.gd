extends Node2D

class_name PixelSnapped

# usage: make this node the parent of a CanvasItem you want snapped to worldspace integer boundaries
# only apply this to purely visual node hierarchies

func _process(delta: float) -> void:
	var parent = get_parent()
	if parent == null:
		return
	position.x = round(parent.global_position.x) - parent.global_position.x
	position.y = round(parent.global_position.y) - parent.global_position.y

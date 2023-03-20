extends Line2D

@export var player_center : Marker2D
@export var crosshair_final : Sprite2D
@export var crosshair_far : Sprite2D
@export var crosshair_close : Sprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var pointcount = self.get_point_count()
	var line = crosshair_close.position.distance_to(player_center.position)
	var center_pos = get_parent().global_transform.origin
	var inner_pos = get_global_mouse_position()
	var mouse_dir = (inner_pos - center_pos).normalized()
	var line_width = 5
	var max_tension = 10000
	var tension_scale = 0.03
	
	var tension = clamp((line) * tension_scale, 0, max_tension)
	
#	if pointcount == 0 and self.points.is_empty():
#			self.add_point((pipca_center.position), 0)
#			#self.add_point((crosshair_far.position), 1)
#			self.add_point((crosshair_final.position), 2)
#			#self.show()
#	if pointcount != 0 and !self.points.is_empty():
#		self.set_point_position(0, crosshair_close.position)
#		#self.set_point_position(1, crosshair_far.position)
#		self.set_point_position(2, crosshair_final.position)
#		self.width = line_width + tension 
#		#self.show()

extends Node2D
class_name PixelPerfectCamera
 
enum PanState { FIXED, NARROW, WIDE }
 
@export var camera : Camera2D
 
# Set this to the node you want the camera to track.
var following = null
 
# How far the `following` position can stray from the centre of the screen.
var box_radius: Vector2 = Vector2(400.0, 100.0)
 
# Set this to temporarily offset the camera from `following` position,
# for example to look up or down.
var offset: Vector2 = Vector2()
 
# Internal variables. Do not set externally.
var current_global_pos = null
var target_offset: Vector2 = Vector2()
var pan_state: PanState:
	get:
		return pan_state
	set(value):
		pan_state = value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	following = Global.skin
	
	if following == null:
		#print ("not following")
		return
		
	if pan_state == PanState.FIXED:
		#print ("pan state is fixed, following position")
		position = following.position
		return 
	
	var delta_offset = target_offset - offset
	if delta_offset.length() > 1.0:
		# Use uniform motion rather than lerp
		var v = delta * 200.0
		if delta_offset.x > v:
			offset.x += v
		elif delta_offset.x < -v:
			offset.x -= v
		else:
			offset.x = target_offset.x
		
		if delta_offset.y > v:
			offset.y += v
		elif delta_offset.y < -v:
			offset.y -= v
		else:
			offset.y = target_offset.y
	else:
		offset = target_offset
		
	if following != null:
		var parent_global = following.global_position
		var virtual_target = parent_global + offset
		
		if current_global_pos == null:
			current_global_pos = global_position
			
		var pos_delta = virtual_target - current_global_pos
		var panning = false 
		match pan_state:
			PanState.WIDE:
				if absf(pos_delta.x) >= 60.0 or absf(pos_delta.y) >= 40.0:
					pan_state = PanState.NARROW
					panning = true
				else:
					panning = false
					
			PanState.NARROW:
				if absf(pos_delta.x) <= 20.0 and absf(pos_delta.y) <= 15.0:
					pan_state = PanState.WIDE
					panning = false
				else:
					panning = true
					
		if panning:
			var speed = pos_delta.length() / 30.0
			#var new_pos = Tools.lerp_vec(current_global_pos, virtual_target, clampf(speed, 0.5, 2.0) * delta)
			var new_pos = lerp(current_global_pos, virtual_target, clampf(speed, 0.5, 2.0) * delta)
			
			# Also correct to keep the `following` position within the box_radius on screen.
			new_pos = keep_visible(new_pos, parent_global)
			
			current_global_pos = new_pos
			global_position = new_pos
 
 
func keep_visible(current_pos: Vector2, keep_visible: Vector2) -> Vector2:
	current_pos.x = clampf(current_pos.x, keep_visible.x - self.box_radius.x, keep_visible.x + self.box_radius.x)
	current_pos.y = clampf(current_pos.y, keep_visible.y - self.box_radius.y, keep_visible.y + self.box_radius.y)
	return current_pos
 
 
func follow(node: Node2D) -> void:
	print ("FOLLOWING")
	pan_state = PanState.WIDE
	following = node
	global_position = node.global_position
	camera.enabled = true
 
 
func set_offset(_offset: Vector2) -> void:
	offset = _offset
 
 
func clear_offset() -> void:
	set_offset(Vector2.ZERO)

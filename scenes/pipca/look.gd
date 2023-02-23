extends Marker2D

@export_category("Debug")
@export var close_radius : float
@export var close_deadzone : float
@export var close_follow_speed : float = 4.0
@export var close_recall_speed : float

@export var far_radius : float
@export var far_deadzone : float
@export var far_follow_speed : float
@export var far_recall_speed : float

@export var final_radius : float
@export var final_deadzone : float
@export var final_follow_speed : float
@export var final_recall_speed : float

@export var crosshair_close : Sprite2D
@export var crosshair_far : Sprite2D
@export var crosshair_final : Sprite2D
@export var line : Line2D

@export var bounds_radius : float

var pulling: bool = false
var center_fixed : Vector2

@onready var pipca_center : Vector2 = get_parent().origin.position
@onready var pipca_global : Vector2 = get_parent().global_transform.origin.normalized()
@onready var fart_charge = get_parent().fart_charge
@onready var max_fart_charge = get_parent().max_fart_charge
@onready var original_pos = get_parent().original_mouse_pos
@onready var current_pos 
@onready var only_once : bool = true

var current_inner_pos_meal
var pointcount : int

var initial_mouse_position : Vector2
var last_mouse_position : Vector2
var initial_mouse_distance_from_crosshair : float

func _ready() -> void:
	pulling = false

func _physics_process(delta: float) -> void:
	
	var pulled = crosshair_close.global_transform.origin.distance_to(crosshair_final.global_transform.origin)
	
	#print (pulled)
	
	get_parent().fart_charge = clampf(remap(pulled, 0.0, 72.0, 0.0, 1.0), 0.0, 1.0)
	
	#print (pulled)
	pointcount = line.get_point_count()
	var raw_mouse_pos = get_local_mouse_position()
	
	var line_length = raw_mouse_pos.distance_to(pipca_center)
	
	if pulling:
		
		#print("pulling")
		tension(delta)
		
		var out_of_bounds : bool 
		
		if line_length >= bounds_radius and Input.is_action_pressed("in_charge"):
			out_of_bounds = true
		
		if not out_of_bounds:
			follow_crosshair(delta)
			crosshair_close.show()
			#crosshair_far.show()
			crosshair_final.show()
			#crosshair_far.global_position = crosshair_far.global_position
			crosshair_final.global_position = crosshair_final.global_position
		
		if only_once:
			#if not out_of_bounds:
				#print("Not out of bounds")
			initial_mouse_position = get_global_mouse_position()
			#print (initial_mouse_position)
			#initial_mouse_distance_from_crosshair = initial_mouse_position.distance_to(crosshair_far.global_transform.origin)
			#print (initial_mouse_distance_from_crosshair)
			only_once = false
			
			if out_of_bounds:
				#print ("Out of bound call") # If clicks out of bounds once
				only_once = false
			else:
				#print ("Else if out of bounds")
				only_once = false
				
				
		
		
	else:
		#print("not pulling")
		#print ("Truly Rancid Else")
		only_once = true
		#crosshair_far.hide()
		#crosshair_final.hide()
		#crosshair_close.hide()
		if pointcount != 0:
			line.clear_points()
			crosshair_close.hide()
		center_fixed = get_parent().global_position
		#crosshair_far.global_position = crosshair_far.global_position.lerp(crosshair_close.global_position, delta * far_recall_speed)
		crosshair_final.global_position = crosshair_final.global_position.lerp(crosshair_close.global_position, delta * final_recall_speed)
		crosshair_close.global_position = crosshair_close.global_position.lerp(center_fixed, delta * close_recall_speed)

func follow_crosshair(delta) -> void:	
	var center_pos = get_parent().global_transform.origin
	var inner_pos = get_global_mouse_position()
	var mouse_dir = (inner_pos - center_pos).normalized()
	var distance = inner_pos.distance_to(center_pos)
	
	if distance > close_radius:
		inner_pos = center_pos + (mouse_dir * close_radius)

	if distance < close_deadzone:
		inner_pos = center_pos + (mouse_dir * close_deadzone)

	crosshair_close.global_transform.origin = crosshair_close.global_transform.origin.lerp(inner_pos, delta * close_follow_speed)
	
	
	var center_pos2 = get_parent().global_transform.origin
	var inner_pos2 = get_global_mouse_position()
	var mouse_dir2 = (inner_pos - center_pos).normalized()
	var distance2 = inner_pos.distance_to(center_pos)
	
	if distance2 > final_radius:
		inner_pos2 = center_pos2 + (mouse_dir2 * final_radius)

	if distance2 < final_deadzone:
		inner_pos2 = center_pos2 + (mouse_dir2 * final_deadzone)

	crosshair_final.global_transform.origin = crosshair_final.global_transform.origin.lerp(inner_pos2, delta * final_follow_speed)
	
func tension(delta) -> void:
	var rmp = get_local_mouse_position()
	
	var line_l = rmp.distance_to(pipca_center)
	
	var center_pos = get_parent().global_transform.origin
	var inner_pos = get_global_mouse_position()
	var mouse_dir = (inner_pos - center_pos).normalized()
	var distance = inner_pos.distance_to(center_pos)
	
	var line_width = 5
	var max_tension = 10000
	var tension_scale = 0.03
	
	var tension = clamp((line_l) * tension_scale, 0, max_tension)
	
	var fixed_mouse_pos : Vector2 = rmp
	
	if distance > far_radius:
		inner_pos = center_pos + (mouse_dir * far_radius)

	if distance < far_deadzone:
		inner_pos = center_pos + (mouse_dir * far_deadzone)

	#cro.global_transform.origin = crosshair_close.global_transform.origin.lerp(inner_pos, delta * far_follow_speed)
	
	crosshair_final.global_transform.origin = crosshair_final.global_transform.origin.lerp(inner_pos, delta * final_recall_speed)

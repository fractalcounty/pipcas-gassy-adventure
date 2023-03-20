extends Area2D
class_name Consumer

@export_group("Scenes")
@export var points_label : PackedScene
@export var food_particles : PackedScene

@export_group("Floating Label")
@export var label_start_marker : Marker2D
@export var label_end_marker : Marker2D
@export var label_move_speed : float = 10
@export var label_shrink_delay : float = 1.0
@export var label_shrink_speed : float = 1.0

@onready var points_label_instance : Node2D
@onready var food_particles_instance : GPUParticles2D


func _physics_process(delta: float) -> void:
	_orient_particles()

func _orient_particles() -> void:
	if get_parent().velocity.x > 0:
		if is_instance_valid(food_particles_instance):
			food_particles_instance.position.x = 20
	elif get_parent().velocity.x < 0:
		if is_instance_valid(food_particles_instance):
			food_particles_instance.position.x = -20

func emit_food_particles() -> void:
	food_particles_instance = food_particles.instantiate()
	add_child(food_particles_instance)
	if Global.player.velocity.x > 0:
		food_particles_instance.process_material.direction = Vector3(200, -120 ,0)
	else:
		food_particles_instance.process_material.direction = Vector3(-200, -120 ,0)

func init_points_label(value: float) -> void:
	points_label_instance = points_label.instantiate()
	add_child(points_label_instance)
	
	await is_instance_valid(points_label_instance)
	var startpos : Vector2 = label_start_marker.global_position
	var endpos : Vector2 = label_end_marker.global_position
	var move_speed : float = label_move_speed
	var shrink_delay : float = label_shrink_delay
	var shrink_speed : float = label_shrink_speed
	points_label_instance.init(value, move_speed, shrink_delay, shrink_speed, startpos, endpos)

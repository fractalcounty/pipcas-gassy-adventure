extends Area2D
class_name Consumer

@export var points_label : PackedScene
@export var food_particles : PackedScene

@onready var points_label_instance : Label
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
	if Global.pipca.velocity.x > 0:
		food_particles_instance.process_material.direction = Vector3(200, -120 ,0)
	else:
		food_particles_instance.process_material.direction = Vector3(-200, -120 ,0)

func emit_points_label(value) -> void:
	points_label_instance = points_label.instantiate()
	add_child(points_label_instance)
	points_label_instance.text = str(value)
	points_label_instance.global_position = global_position

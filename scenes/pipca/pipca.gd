extends CharacterBody2D
class_name Pipca

@export_group("Physics")
@export var push_force : float = 500.0

@export_group("Pipca Anatomy")
@export var particle_label : PackedScene
@export var eat_particles : PackedScene
@export var skin : Sprite2D
@export var shadow : LightOccluder2D
@export var mouth : Marker2D
@export var origin : Marker2D
@export var anim : AnimationPlayer
@export var charging_shaker : Shaker
@export var charged_shaker : Shaker
@export var raycast : RayCast2D
@export var collision_shape : CollisionShape2D
@export var bottom : Marker2D
@export var look : Marker2D
@export var mouse_area : Area2D
@export var mouse_area_shape : CollisionShape2D
@export var belch_sounds : AudioStreamPlayer
@export var fart_sounds : AudioStreamPlayer

@export_group("Movement Parameters")
@export var gravity : float = 2500

@export_subgroup("Air Physics")
@export var air_top_margin : float = 50
@export var air_speed : float = 300.0
@export var air_accel : float = 6.0
@export var air_friction : float = 10.0

@export_subgroup("Ground Physics")
@export var ground_friction : float = 10.0
@export var ground_speed : float = 450.0
@export var acceleration : float = 6.0
@export var walk_margin : float = 20.0

@export_subgroup("Fart Physics")
@export var fart_anim_speed : float = 200
@export var ground_fart_speed : float = 250
@export var fart_rotation_control : float = 5.0
@export var fart_charge_duration : float = 3.0
@export var meter_multiplier : float = 3.0
@export var fart_min_height : float = 16
@export var fart_max_height : float = 48
@export var fart_max_charge_time : float = 3.0

@export_subgroup("Charging Stuff")
@export var max_fart_charge : float = 200.0
var tension : float
var fart_charge : float = 0.0
var current_mouse_pos : Vector2
var original_mouse_pos : Vector2
var smooth_time : float

@onready var time_charged : float = 0.0
@onready var enable_physics : bool = true
@onready var lifetime : float
@onready var dir : float
@onready var pull_length : float


@onready var points : float = 0.0
@onready var max_points : float = 10.0
@onready var particle_label_instance : Label
@onready var eat_particles_instance : GPUParticles2D

var sprite : AnimatedSprite2D
var coll_normal : Vector2
var coll
var angle
var slopeAngle = 0
var slopeNormal = Vector2.ZERO


func _ready():
	Events.pipca_spawned.emit(self)
	anim.play("idle_still")
	Global.pipca = self

func _physics_process(delta: float) -> void:
	if enable_physics:
		move_and_slide()
	
	if velocity.x > 0:
		skin.flip_h = false
		shadow.scale.x = 1
		if is_instance_valid(eat_particles_instance):
			eat_particles_instance.position.x = 20
	elif velocity.x < 0:
		skin.flip_h = true
		shadow.scale.x = -1
		if is_instance_valid(eat_particles_instance):
			eat_particles_instance.position.x = -20
	
	if is_on_floor():
		Global.is_grounded = true
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			slopeAngle = -get_floor_angle()
			skin.rotation = slopeAngle
			var tweener = get_tree().create_tween()
			tweener.tween_property(skin, "rotation", slopeAngle, 0.8)
			if skin.rotation != 0:
				#var lerpy = lerp(0, 10, 0.5 * delta)
				#skin.offset.y = lerpy
				var tween = get_tree().create_tween()
				tween.tween_property(skin, "offset:y", 6.0, 0.5)
				#print (skin.offset.y)
			else:
				var tween = get_tree().create_tween()
				tween.tween_property(skin, "offset:y", 0.0, 0.1)
		
			
	else:
		Global.is_grounded = false
	
	#Global.debug.value(fart_charge)
	#Global.debug2.value2(tension)
	
	coll = raycast.get_collider()
	var origin_pos : Vector2 = (self.position)
	Events.follow_origin.emit(origin_pos)
	
#	push_object()
#
#func push_object() -> void:
#	if enable_physics: # true if collided
#		for i in get_slide_collision_count():
#			var col = get_slide_collision(i)
#			if col.get_collider().is_in_group("phys_objects"):
#				print ("pushing")
#				col.get_collider().apply_central_impulse(col.get_normal() * -push_force)

func spawn_eat_particles() -> void:
	eat_particles_instance = eat_particles.instantiate()
	add_child(eat_particles_instance)
	if Global.pipca.velocity.x > 0:
		eat_particles_instance.process_material.direction = Vector3(200, -120 ,0)
	else:
		eat_particles_instance.process_material.direction = Vector3(-200, -120 ,0)

func spawn_particle_label(value) -> void:
	particle_label_instance = particle_label.instantiate()
	add_child(particle_label_instance)
	particle_label_instance.text = str(value)
	particle_label_instance.global_position = global_position

func play_belch():
	belch_sounds.play()

func set_smooth_time(value: float):
	smooth_time = value

#func emit_fart():
##	var fart_scene = load("res://scenes/fart/fart_sprite.tscn")
##	var fart_instance = fart_scene.instantiate()
##	add_child(fart_instance)
##	sprite = $FartSprite
#	if coll_normal.x < 0:
#		sprite.scale.x = -1
#	else:
#		sprite.scale.x = 1
	
func _process(delta: float) -> void:
	coll_normal = raycast.get_collision_normal()

func _exit_tree() -> void:
	Global.pipca = null

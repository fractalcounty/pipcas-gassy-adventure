extends CharacterBody2D
class_name Pipca

@export_group("Pipca Anatomy")
@export var skin : Sprite2D
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


var sprite : AnimatedSprite2D
var coll_normal : Vector2
var coll
var angle


func _ready():
	anim.play("idle_still")
	Global.pipca = self

func _physics_process(delta: float) -> void:
	if enable_physics:
		move_and_slide()
	
	if self.is_on_floor():
		Global.is_grounded = true
	else:
		Global.is_grounded = false
	
	Global.debug.value(fart_charge)
	#Global.debug2.value2(tension)
	
	coll = raycast.get_collider()
	var origin_pos : Vector2 = (self.position)
	Events.follow_origin.emit(origin_pos)

func play_belch():
	belch_sounds.play()

func set_smooth_time(value: float):
	smooth_time = value

func emit_fart():
	var fart_scene = load("res://scenes/fart/fart_sprite.tscn")
	var fart_instance = fart_scene.instantiate()
	add_child(fart_instance)
	sprite = $FartSprite
	if coll_normal.x < 0:
		sprite.scale.x = -1
	else:
		sprite.scale.x = 1
	
func _process(delta: float) -> void:
	coll_normal = raycast.get_collision_normal()


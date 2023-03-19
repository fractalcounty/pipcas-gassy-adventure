extends CharacterBody2D
class_name Pipca

@export_group("Anatomy")
@export var skin : Sprite2D
@export var occluder : LightOccluder2D
@export var anim : AnimationPlayer
@export var charging_shaker : Shaker
@export var charged_shaker : Shaker
@export var raycast : RayCast2D
@export var collision_shape : CollisionShape2D
@export var belch_sounds : AudioStreamPlayer
@export var fart_sounds : AudioStreamPlayer
@export var consumer : Area2D

@export_group("Movement")
@export var enable_physics : bool = true

@export_subgroup("Air")
@export var gravity : float = 2500
@export var air_speed : float = 300.0
@export var air_accel : float = 6.0
@export var air_friction : float = 10.0

@export_subgroup("Ground")
@export var dash_speed : float = 450.0
@export var dash_acceleration : float = 6.0
@export var ground_friction : float = 10.0
@export var ground_speed : float = 450.0
@export var acceleration : float = 6.0
@export var walk_margin : float = 20.0

@export_subgroup("Jump")
@export var fart_anim_speed : float = 200
@export var ground_fart_speed : float = 250
@export var fart_min_height : float = 16
@export var fart_max_height : float = 48
@export var fart_max_charge_time : float = 3.0

var fart_charge : float = 0.0
var lifetime : float
var dir : float
var pull_length : float

func _ready():
	Events.pipca_spawned.emit(self)
	Global.pipca = self
	anim.play("idle_still")

func _physics_process(delta: float) -> void:
	if enable_physics:
		move_and_slide()
		_auto_flip()
		
		if is_on_floor():
			Global.is_grounded = true
			_auto_rotate()

func _auto_flip() -> void:
	if velocity.x > 0:
		skin.flip_h = false
		occluder.scale.x = 1
	elif velocity.x < 0:
		skin.flip_h = true
		occluder.scale.x = -1

func _auto_rotate() -> void:
	var slopeAngle = 0
	var slopeNormal = Vector2.ZERO
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		slopeAngle = -get_floor_angle()
		skin.rotation = slopeAngle
		var tweener = get_tree().create_tween()
		tweener.tween_property(skin, "rotation", slopeAngle, 0.8)
		
		if skin.rotation != 0:
			var tween = get_tree().create_tween()
			tween.tween_property(skin, "offset:y", 6.0, 0.5)
		else:
			var tween = get_tree().create_tween()
			tween.tween_property(skin, "offset:y", 0.0, 0.1)

func _exit_tree() -> void:
	Global.pipca = null

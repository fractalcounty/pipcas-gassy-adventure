@icon("res://assets/icons/CharacterEffects.svg")
extends Node2D

@export var player : Player
@export var ghost_effect : PackedScene
@export var slam_impact : PackedScene
@export var dash_cloud : PackedScene
@export var jump_cloud : PackedScene
@export var land_cloud : PackedScene
@export var taunt : PackedScene

var body_slam_instance : AnimatedSprite2D = null
var ghost_effect_instance : Node2D = null
var dash_cloud_instance : Node2D = null
var taunt_effect_instance : AnimatedSprite2D = null

@onready var effects_node : Node2D = get_node("/root/Game/SubViewportContainer/SubViewport/level_debug/Effects")

func spawn_jump_cloud() -> void:
	var jump_cloud_instance : AnimatedSprite2D = jump_cloud.instantiate()
	jump_cloud_instance.global_position = player.feet.global_position
	effects_node.add_child(jump_cloud_instance)
	jump_cloud_instance.play("default")
	jump_cloud_instance.animation_finished.connect(jump_cloud_instance.queue_free)

func spawn_land_cloud() -> void:
	var land_cloud_instance : AnimatedSprite2D = land_cloud.instantiate()
	land_cloud_instance.global_position = player.feet.global_position
	effects_node.add_child(land_cloud_instance)
	land_cloud_instance.play("default")
	land_cloud_instance.animation_finished.connect(land_cloud_instance.queue_free)

func spawn_slam_impact() -> void:
	if body_slam_instance == null:
		body_slam_instance = slam_impact.instantiate()
		body_slam_instance.global_position = player.feet.global_position
		effects_node.add_child(body_slam_instance)
		body_slam_instance.play("default")
		body_slam_instance.animation_finished.connect(body_slam_instance.queue_free)

func start_ghost_effect(mach: bool, frequency: float, decay: float) -> void:
	if ghost_effect_instance == null or not is_instance_valid(ghost_effect_instance):
		ghost_effect_instance = ghost_effect.instantiate()
		effects_node.add_child(ghost_effect_instance)
		ghost_effect_instance.start(player.sprite, mach, frequency, decay)
	else:
		ghost_effect_instance.update(mach, frequency, decay)

func stop_ghost_effect() -> void:
	if is_instance_valid(ghost_effect_instance):
		ghost_effect_instance.stop()

func spawn_dash_cloud() -> void:
	dash_cloud_instance = dash_cloud.instantiate()
	effects_node.add_child(dash_cloud_instance)
	dash_cloud_instance.play(player)

func spawn_taunt_effect(duration: float) -> void:
	taunt_effect_instance = taunt.instantiate()
	taunt_effect_instance.global_position = player.global_position
	effects_node.add_child(taunt_effect_instance)
	taunt_effect_instance.start()

func stop_taunt_effect() -> void:
	if is_instance_valid(taunt_effect_instance):
		taunt_effect_instance.clear()

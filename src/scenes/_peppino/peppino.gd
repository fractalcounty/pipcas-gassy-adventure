extends CharacterBody2D
class_name Player

@export_group("Anatomy")
@export var effects : Node2D
@export var sound : Node2D
@export var sprite : AnimatedSprite2D
@export var stand_collision : CollisionShape2D
@export var crouch_collision : CollisionShape2D
@export var consumer : Area2D
@export var dust_particles : GPUParticles2D
@export var idle_timer : Timer
@export var taunt_timer : Timer
@export var sprite_animations : AnimationPlayer
@export var feet : Marker2D

@export_group("Movement")
@export_subgroup("Global")
@export var speed : float = 200.0 ## Base player speed value
@export var max_speed: float = 200.0  # Maximum horizontal speed player will accelerate to
@export var acceleration: float = 1200.0  # Acceleration while moving
@export var deceleration: float = 1800.0  # Deceleration while not moving
@export var air_acceleration: float = 800.0  # Acceleration while in the air
@export var taunt_duration : float = 1.0 ## Taunt duration in seconds
@export var dash_speed: float = 50.0 ## Maximum height for ground jumps (when holding a jump)
@export_range(0.1, 1.0, 0.05) var crawl_speed_multiplier : float = 0.5 ## The value "speed" is multiplied by when crawling

@export_subgroup("Sound & FX")
@export var move_step_interval : float = 0.1 ## Seconds between when a step sound may be played when moving
@export var crawl_step_interval : float = 0.1 ## Seconds between when a step sound may be played when crawling
@export var idle_random_interval : Vector2 = Vector2(1.0, 5.0) ## Range in seconds that a random animation may be picked

@export_group("Jumps")
@export_subgroup("Jump")
@export var jump_height : float = 150
@export var jump_time_to_peak : float = 0.375 
@export var jump_time_to_descent : float = 0.375
@export var jump_max_hold_time : float = 0.3 

@export_subgroup("CrouchJump")
@export var crouch_jump_height : float = 150.0
@export var crouch_jump_time_to_peak : float = 0.375 
@export var crouch_jump_time_to_descent : float = 0.375

@export_subgroup("LongJump")
@export var long_jump_height : float = 150.0
@export var long_jump_time_to_peak : float = 0.4 
@export var long_jump_time_to_descent : float = 0.4

@export_subgroup("GrabAirJump")
@export var grab_air_jump_height : float = 150.0
@export var grab_air_jump_time_to_peak : float = 0.4 
@export var grab_air_jump_time_to_descent : float = 0.4

@export_subgroup("GrabJump")
@export var grab_jump_height : float = 150.0
@export var grab_jump_time_to_peak : float = 0.4 
@export var grab_jump_time_to_descent : float = 0.4

@export_subgroup("Body Slam")
@export var body_slam_height : float = 300
@export var body_slam_time_to_peak : float = 0.25
@export var body_slam_time_to_descent : float = 0.10

## Misc vars
@onready var dir : String
var footstep_timer: float = 0.0
var play_crouch_start : bool = true
var emit_dust: bool = false
var input_enabled: bool = true
var input : Vector2 = Vector2.ZERO
var move_input_float : float = 0.0

func _ready():
	Events.player_spawned.emit(self)
	Events.player_ready.emit(self)

func _physics_process(delta) -> void:
	_auto_flip()
	
	if input_enabled:
		input = Vector2(Input.get_action_strength("right") - Input.get_action_strength("left"),0)
	
	dust_particles.emitting = emit_dust

func _auto_flip() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
		dust_particles.process_material.direction.x = -1
		dir = "right"
	elif velocity.x < 0:
		sprite.flip_h = true
		dust_particles.process_material.direction.x = 1
		dir = "left"

func do_horizontal_movement(_delta) -> void:
	velocity.x += air_acceleration * input.x * _delta
	velocity.x = clamp(velocity.x, -max_speed, max_speed)

func is_moving() -> bool:
	return true if abs(input.x) > 0 else false

func _exit_tree() -> void:
	Events.player_exit.emit(self)

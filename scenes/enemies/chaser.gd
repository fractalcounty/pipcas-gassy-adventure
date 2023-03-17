extends CharacterBody2D

@export_category("Anatomy")
@export var line : Line2D
@export var sprite : Sprite2D
@export var hitbox : CollisionShape2D
@export var agent : NavigationAgent2D
@export var timer: Timer
@export var target : Pipca

@export_category("Properties")
@export var gravity_multiplier : Vector2 = Vector2(0, 0)
@export var mass : float = 5.0
@export var speed : float = 200.0
@export_range(0.0 , 1.0) var acceleration : float = 0.25
@export var max_scale : float = 2.0  # maximum scale for the sprite
@export var min_scale : float = 0.5  # minimum scale for the sprite
@export var max_distance : float = 500.0  # maximum distance at which the sprite should be at its smallest scale
@export var min_distance : float = 50.0  # minimum distance at which the sprite should be at its largest scale
@export var flip_offset : float = 5.0

@export_category("Collisions")
@export var hitbox_radius : float = 0.5

var direction : Vector2 = Vector2.RIGHT
var old_vel : Vector2 = Vector2.ZERO

func _ready() -> void:
	_update_pathfinding()
	timer.connect("timeout", _update_pathfinding)

	hitbox.shape.radius = hitbox_radius
	
func _physics_process(delta) -> void:
	
	#if agent.is_navigation_finished():
		#return

	var direction := global_position.direction_to(agent.get_next_path_position())
	
	var desired_velocity : Vector2 = lerp(velocity, direction * speed, acceleration)
	var steering = ((desired_velocity - velocity) / mass)
	
	velocity += steering

	move_and_slide()
	rotation = velocity.angle()
	
	_set_scale(delta)
	_set_rotation(delta)

func _update_pathfinding() -> void:
	agent.target_position = Global.pipca.global_position
	var final_pos : Vector2 = agent.get_next_path_position()
	var angle : Vector2 = global_position.direction_to(final_pos)
	
	#print (line.gravity)

func _set_rotation(delta) -> void:
	var final_pos : Vector2 = agent.get_next_path_position()
	var angle : float = global_position.angle_to_point(final_pos)
	#var clamped_angle = clamp(angle, -0.8, 0.8)
	sprite.rotation = lerp(sprite.rotation, angle, delta * 1)

func _set_scale(delta) -> void:
	var dist = position.distance_to(Global.pipca.global_position)
	var scale_factor = (max_distance - dist) / (max_distance - min_distance)
	var scalex = clamp(scale_factor * max_scale, min_scale, max_scale)
	var scaley = clamp(scale_factor * max_scale, min_scale, max_scale)
	sprite.scale.x = lerp(sprite.scale.x, scalex, delta * 5)
	sprite.scale.y = lerp(sprite.scale.y, scaley, delta * 5)

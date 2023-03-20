extends CharacterBody2D
class_name Player

enum PlayerState {IDLE, MOVE, CROUCH, JUMP, FALL, CRAWL, TAUNT}

@export_group("Anatomy")
@export var state_label : Label
@export var sprite : AnimatedSprite2D
@export var collision : CollisionShape2D
@export var consumer : Area2D
@export var dust_particles : GPUParticles2D
@export var step_sound : AudioStreamPlayer
@export var jump_sound : AudioStreamPlayer
@export var taunt_sound : AudioStreamPlayer
@export var taunt_effect : AnimatedSprite2D

@export_category("Movement")
@export var speed : float = 200.0
@export var crawl_speed : float = 0.5
@export var jump_strength : float = 500.0
@export var gravity : float = 1000.0
@export var jump_buffer_time : float = 0.15
@export var crouch_buffer_time : float = 0.15

var footstep_timer: float = 0.0
var taunt_input: bool = false
var play_crouch_start : bool = true
var jump_buffer_timer: float = 0.0
var crouch_buffer_timer: float = 0.0
var emit_dust: bool = false
var state: PlayerState = PlayerState.IDLE
var state_str: String = "IDLE"
var input_enabled: bool = true
var move_input_vector : Vector2 = Vector2.ZERO
var move_input_float : float = 0.0

func _ready():
	Events.player_spawned.emit(self)
	Global.player = self

func _input(event: InputEvent) -> void:
	taunt_input = event.is_action_pressed("taunt")

func set_state(new_state: PlayerState) -> void:
	if state != PlayerState.CRAWL and new_state == PlayerState.CROUCH:
		play_crouch_start = true
	state = new_state
	_play_state_sound(new_state)
	match new_state:
		PlayerState.IDLE:
			state_str = "IDLE"
		PlayerState.MOVE:
			state_str = "MOVE"
		PlayerState.JUMP:
			state_str = "JUMP"
		PlayerState.CROUCH:
			state_str = "CROUCH"
		PlayerState.FALL:
			state_str = "FALL"
		PlayerState.CRAWL:
			state_str = "CRAWL"
		PlayerState.TAUNT:
			state_str = "TAUNT"

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	if Input.is_action_just_pressed("crouch"):
		crouch_buffer_timer = crouch_buffer_time
	
	if input_enabled:
		move_input_vector = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),0)
		move_input_float = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	dust_particles.emitting = emit_dust
	if state == PlayerState.MOVE and is_on_floor() or state == PlayerState.CRAWL and is_on_floor():
		footstep_timer -= delta
		if footstep_timer <= 0:
			_play_step_sound()
	
	match state:
		PlayerState.IDLE:
			_idle_state(delta)
			state_label.set_text("IDLE")
		PlayerState.MOVE:
			_move_state(delta)
			state_label.set_text("MOVE")
		PlayerState.JUMP:
			_jump_state(delta)
			state_label.set_text("JUMP")
		PlayerState.CROUCH:
			_crouch_state(delta)
			state_label.set_text("CROUCH")
		PlayerState.FALL:
			_fall_state(delta)
			state_label.set_text("FALL")
		PlayerState.CRAWL:
			_crawl_state(delta)
			state_label.set_text("CRAWL")
		PlayerState.TAUNT:
			_taunt_state(delta)
			state_label.set_text("TAUNT")
	
	_apply_gravity(delta)
	_auto_flip()

func _idle_state(delta: float) -> void:
	emit_dust = false
	velocity.x = 0
	sprite.play("idle")

	if not is_on_floor():
		set_state(PlayerState.FALL)
	
	# Might need to put everything behind an "else" here
	
	if move_input_vector.x != 0:
		set_state(PlayerState.MOVE)
	elif (Input.is_action_just_pressed("jump") or jump_buffer_timer > 0) and is_on_floor():
		jump_buffer_timer = 0
		set_state(PlayerState.JUMP)
	
	if Input.is_action_just_pressed("taunt"):
		print ("taunt input")
		set_state(PlayerState.TAUNT)
	
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta

	elif (Input.is_action_just_pressed("crouch") or crouch_buffer_timer > 0) and is_on_floor():
		crouch_buffer_timer = 0
		set_state(PlayerState.CROUCH)
	
	if crouch_buffer_timer > 0:
		crouch_buffer_timer -= delta

	_apply_gravity(delta)
	move_and_slide()

func _move_state(delta: float) -> void:

	if is_on_floor() and abs(move_input_vector) as float > 0:
		velocity.x = move_input_vector.x * speed
		sprite.play("move")
		emit_dust = true
		dust_particles.restart
	else:
		emit_dust = false

	if not is_on_floor():
		set_state(PlayerState.FALL)
	
	# Might need to put everything behind an "else" here
	
	if move_input_vector.x == 0:
		set_state(PlayerState.IDLE)
	elif (Input.is_action_just_pressed("jump") or jump_buffer_timer > 0) and is_on_floor():
		jump_buffer_timer = 0
		set_state(PlayerState.JUMP)
	
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
	
	elif (Input.is_action_just_pressed("crouch") or crouch_buffer_timer > 0) and is_on_floor():
		crouch_buffer_timer = 0
		set_state(PlayerState.CROUCH)
	
	if crouch_buffer_timer > 0:
		crouch_buffer_timer -= delta

	if Input.is_action_just_pressed("taunt"):
		print ("taunt input")
		set_state(PlayerState.TAUNT)
	
	_apply_gravity(delta)
	move_and_slide()

func _jump_state(delta: float) -> void:
	
	sprite.play("jump")
	emit_dust = false
	
	if is_on_floor():
		if Input.is_action_pressed("jump"):
			velocity.y = -jump_strength
		else:
			set_state(PlayerState.IDLE)
	else:
		if velocity.y > 0:
			set_state(PlayerState.FALL)

	velocity.x = move_input_vector.x * speed

	if Input.is_action_just_pressed("taunt"):
		print ("taunt input")
		set_state(PlayerState.TAUNT)
	
	_apply_gravity(delta)
	move_and_slide()

func _fall_state(delta: float) -> void:
	
	sprite.play("fall")
	emit_dust = false
	
	if Input.is_action_just_pressed("taunt"):
		print ("taunt input")
		set_state(PlayerState.TAUNT)
	
	if is_on_floor():
		set_state(PlayerState.IDLE)
	else:
		velocity.x = move_input_vector.x * speed
		
		_apply_gravity(delta)
		move_and_slide()

func _crouch_state(delta: float) -> void:
	
	velocity.x = 0
	emit_dust = false
	
	if play_crouch_start and sprite.animation != "crouch_start" and sprite.animation != "crouch":
		sprite.play("crouch_start")
	elif not play_crouch_start and sprite.animation != "crouch":
		sprite.play("crouch")

	if abs(move_input_float) > 0:
		set_state(PlayerState.CRAWL)
	elif not Input.is_action_pressed("crouch"):
		set_state(PlayerState.IDLE)

	if Input.is_action_just_pressed("taunt"):
		print ("taunt input")
		set_state(PlayerState.TAUNT)
	
	move_and_slide()

func _on_crouch_start_animation_finished() -> void:
	if state == PlayerState.CROUCH and sprite.animation == "crouch_start":
		sprite.play("crouch")

func _crawl_state(delta: float) -> void:
	emit_dust = false
	if not Input.is_action_pressed("crouch"):
		set_state(PlayerState.IDLE)
	else:
		if abs(move_input_float) == 0:
			play_crouch_start = false
			set_state(PlayerState.CROUCH)
		if Input.is_action_just_pressed("taunt"):
			print ("taunt input")
			set_state(PlayerState.TAUNT)
		else:
			velocity.x = move_input_float * speed * crawl_speed
			sprite.play("crawl")

	move_and_slide()

func _taunt_state(delta: float) -> void:
	
	if is_on_floor():
		velocity.x = 0
	else:
		_apply_gravity(delta)
		move_and_slide()
	
	input_enabled = false
	await get_tree().create_timer(0.20).timeout
	input_enabled = true

	
	if move_input_vector.x != 0:
		set_state(PlayerState.MOVE)
		taunt_effect.hide()
	
	await taunt_effect.animation_finished
	set_state(PlayerState.IDLE)
	taunt_effect.hide()
	

func _apply_gravity(delta: float) -> void:
	velocity.y += gravity * delta

func _auto_flip() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
		dust_particles.process_material.direction.x = -1
	elif velocity.x < 0:
		sprite.flip_h = true
		dust_particles.process_material.direction.x = 1

func _play_step_sound() -> void:
	step_sound.pitch_scale = 1.0 + ( randf() - 0.5 ) / 3
	step_sound.play()

	# Set the footstep timer to a slightly varying interval
	if state == PlayerState.MOVE:
		footstep_timer = randf_range(0.2, 0.25)
	elif state == PlayerState.CRAWL:
		footstep_timer = randf_range(0.4, 0.45)

func _play_state_sound(new_state: PlayerState) -> void:
	match new_state:
		PlayerState.JUMP:
			#jump_sound.pitch_scale = 1.0 + ( randf() - 0.5 ) / 3
			jump_sound.play()
		PlayerState.TAUNT:
			taunt_sound.pitch_scale = 1.0 + ( randf() - 0.3 ) / 3
			taunt_sound.play()
			sprite.play("taunt")
			sprite.frame = randi() % 9 + 1
			taunt_effect.show()
			taunt_effect.play("taunt_effect")

func _exit_tree() -> void:
	Global.player = null


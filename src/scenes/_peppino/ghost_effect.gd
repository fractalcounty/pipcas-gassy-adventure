extends Node2D

@export var frequency_timer : Timer
@export var ghost : PackedScene
@export var animation_player : AnimationPlayer
var sprite : AnimatedSprite2D
var decay : float
var instance_counter : int = 0
var mach_effect : bool = false

func _ready() -> void:
	animation_player.animation_finished.connect(_on_anim_finished)

func start(sprite: AnimatedSprite2D, mach: bool, frequency: float, decay: float) -> void:
	self.sprite = sprite
	self.decay = decay
	self.mach_effect = mach
	
	print (mach)
	
	frequency_timer.wait_time = frequency
	frequency_timer.start()
	
	_instance_ghost(decay)

func update(mach, frequency, decay) -> void:
	self.sprite = sprite
	self.decay = decay
	self.mach_effect = mach
	
	frequency_timer.wait_time = frequency
	frequency_timer.start()

func _instance_ghost(decay) -> void:
	var ghost_instance : CanvasGroup = ghost.instantiate()
	ghost_instance.global_position = Global.player.global_position
	add_child(ghost_instance)
	ghost_instance.initialize(sprite)
	
	if mach_effect:
		if instance_counter % 4 == 0 or instance_counter % 4 == 1:
			ghost_instance.modulate = Color.RED
		else:
			ghost_instance.modulate = Color.GREEN
	instance_counter += 1
	
	ghost_instance.start(decay)

func stop() -> void:
	animation_player.play("fade_out")
	
func _on_decay_timer_timeout():
	_instance_ghost(decay)


func _on_anim_finished(anim_name):
	queue_free()

extends AnimatedSprite2D

@export var points_worth : float = 1.0
@export var eat_sound : AudioStreamPlayer
@export var timer : Timer
@export var anim : AnimationPlayer
@export var anim_delay : float = 1.0
@export var collection_direction : Marker2D
@export var lerp_time : float = 0.5

@onready var collecting : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.stop()
	collecting = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var dest_pos : Vector2 = collection_direction.global_position
	if collecting:
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", dest_pos, lerp_time)
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		#var cur_pos : Vector2 = global_position
		#var new_pos = cur_pos.lerp(dest_pos, collection_lerp_mult*delta)
		#global_position = new_pos

func dissapear() -> void:
	self.queue_free()

func _on_timer_timeout() -> void:
	anim.play("eat")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() == Global.pipca:
		eat_sound.play()
		eat_sound.pitch_scale = 1.0 + ( randf() - 0.5 ) / 5
		timer.start(anim_delay)
		collecting = true
		Global.pipca.spawn_eat_particles()
		Global.counter.add_points(points_worth)

extends Node2D

@export var dash_sprite_small : PackedScene
@export var dash_sprite_large : PackedScene
@export var dash_sprite_huge : PackedScene

@export var timer : Timer

func play(player : Player) -> void:
	var cloud1 : AnimatedSprite2D = dash_sprite_huge.instantiate()
	cloud1.global_position = player.feet.global_position
	if player.dir == "left":
		cloud1.flip_h = true
	else:
		cloud1.flip_h = false
	add_child(cloud1)
	await cloud1.find_child("AnimationPlayer").animation_finished
	cloud1.queue_free()

	var cloud2 : AnimatedSprite2D = dash_sprite_large.instantiate()
	cloud2.global_position = player.feet.global_position
	add_child(cloud2)
	await cloud2.animation_finished
	cloud2.queue_free()

	var cloud3 : AnimatedSprite2D = dash_sprite_large.instantiate()
	cloud3.global_position = player.feet.global_position
	add_child(cloud3)
	await cloud3.animation_finished
	queue_free()



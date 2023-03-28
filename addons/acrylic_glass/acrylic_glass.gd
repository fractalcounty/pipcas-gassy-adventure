@icon("icon.svg")

class_name AcrylicGlass
extends TextureRect

# A TextureRect that imitates Microsoft's Acrylic and Mica effects


const blur = preload("blur.gd")

const blur_amount := 50
@export var tint_color := Color("1f1f1f66") :
	set(value):
			if value == tint_color:
				return
			
			tint_color = value
			material.set_shader_parameter("tint", tint_color)
@export var opaque_on_lost_focus := true
@export_range(0, 2, 0.05) var fade_in_duration := 0.1
@export_range(0, 2, 0.05) var fade_out_duration := 0.1

func _init():
	if not material:
		material = preload("acrylic_material.tres").duplicate()
	stretch_mode = STRETCH_TILE


func _ready() -> void:
	material.set_shader_parameter(&"screen_size", DisplayServer.screen_get_size())
	material.set_shader_parameter(&"texture_size", texture.get_size())


func _process(_delta: float) -> void:
	material.set_shader_parameter(
		&"pos_on_screen",
		get_window().position + Vector2i(global_position)
	)

extends Control

@export_group("Anatomy")
@export var play_button : Button
@export var settings_button : Button
@export var quit_button : Button
@export var clouds : ColorRect
@export var shader_display : TextureRect
@export var shader_viewport : SubViewport

@export_subgroup("Debug labels")
@export var label1 : Label
@export var label2 : Label
@export var label3 : Label
@export var label4 : Label
@export var label5 : Label
@export var label6 : Label

@export_subgroup("Logo")
@export var logo1 : Sprite2D
@export var logo2 : Sprite2D
@export var logo3 : Sprite2D
@export var logo4 : Sprite2D
@export var logo5 : Sprite2D
@export var logo6 : Sprite2D

@onready var already_pressed : bool = false
@onready var iMouse : Vector4
@onready var iTime : float
@onready var mouse_pos : Vector2 = Vector2.ZERO
@onready var window_size : Vector2
@onready var screen_size : Vector2 
@onready var screen_transform : Transform2D
@onready var viewport_size : Vector2
@onready var screen_scale : float
@onready var locked_mouse_pos : Vector2
@onready var center : Vector2
@onready var dir_to_center : Vector2
@onready var mpos : Vector2 = Vector2.ZERO
@onready var new_position : Vector2 = Vector2.ZERO
@onready var final_pos : Vector2 = Vector2.ZERO


func _ready():
	mpos = get_global_mouse_position()
	iMouse = Vector4.ZERO
	mouse_pos = Vector2.ZERO
	play_button.grab_focus()
	#shader_display.texture = shader_viewport.get_texture()
	
func _process(delta):
	
	logo2.global_position = logo2.global_position.lerp(logo1.global_position, .250)
	logo3.global_position = logo3.global_position.lerp(logo2.global_position, .100)
	logo4.global_position = logo4.global_position.lerp(logo3.global_position, .050)
	logo5.global_position = logo5.global_position.lerp(logo4.global_position, .040)
	logo6.global_position = logo6.global_position.lerp(logo5.global_position, .035)
	
	logo2.rotation = lerp(logo2.rotation, logo1.rotation, .095)
	logo3.rotation = lerp(logo3.rotation, logo2.rotation, .085)
	logo4.rotation = lerp(logo4.rotation, logo3.rotation, .060)
	logo5.rotation = lerp(logo5.rotation, logo4.rotation, .055)
	logo6.rotation = lerp(logo6.rotation, logo5.rotation, .035)
	
	
	screen_size = DisplayServer.screen_get_size()
	viewport_size = get_viewport().size
	
	var mouse_pos : Vector2 = get_global_mouse_position()
	new_position = new_position.lerp(mouse_pos, 5 * delta)
	new_position.x = remap(mouse_pos.x, 0, viewport_size.x, -viewport_size.x, viewport_size.x)
	new_position.y = remap(mouse_pos.y, 0, viewport_size.y, viewport_size.y, -viewport_size.y)
	final_pos = final_pos.lerp(new_position, 5 * delta)

	screen_scale = DisplayServer.screen_get_scale()
	screen_transform = get_screen_transform()
	center = get_viewport_rect().size/2
	dir_to_center = mouse_pos.direction_to(center)
	
	
	label1.set_text("mouse_pos: " + str(mouse_pos))
	label2.set_text("dir_to_center: " + str(dir_to_center))
	label3.set_text("screen_size: " + str(screen_size))
	label4.set_text("screen_transform: " + str(screen_transform))
	label5.set_text("viewport_size: " + str(viewport_size))
	label6.set_text("screen_scale: " + str(screen_scale))
	
	#bg_canvas_modulate.color = Color(255, 255, 255, 255)
	
	var iChannelResolution1 : Vector2 = Vector2(1.0/viewport_size.x, 1.0/viewport_size.y)
	
	iMouse.x = final_pos.x
	iMouse.y = final_pos.y
	iMouse.z = 0
	iMouse.w = 0
	clouds.material.set_shader_parameter("iMouse",iMouse)
	clouds.material.set_shader_parameter("iDirToCenter",dir_to_center)
	iTime += delta*2
	clouds.material.set_shader_parameter("iTime",iTime/2)
	clouds.material.set_shader_parameter("iChannelResolution1",iChannelResolution1)

func _input(event) -> void:
	if Input.is_action_just_released("click"):
		iMouse.w = 1.0
	else:
		iMouse.w = 0.0
		
	if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_up"):
		UIAudio.click.play()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event is InputEventMouseMotion:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func _exit_tree() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED_HIDDEN)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_play_button_pressed() -> void:
	if !already_pressed:
		get_parent().load_level()
		already_pressed = true

func _on_play_button_mouse_entered() -> void:
	UIAudio.click.play()

func _on_settings_button_mouse_entered() -> void:
	UIAudio.click.play()


func _on_quit_button_mouse_entered() -> void:
	UIAudio.click.play()


func _on_play_button_button_up() -> void:
	UIAudio.unclick.play()


func _on_settings_button_button_up() -> void:
	UIAudio.unclick.play()


func _on_quit_button_button_up() -> void:
	UIAudio.unclick.play()

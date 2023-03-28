extends Control

@onready var state_label_instance : Control = null
@onready var debug_panel_instance : Control = null
@export var debug_panel : PackedScene
@export var state_label : PackedScene

func _ready() -> void:
	Global.debug = self

func load_debug_panel() -> void:
	debug_panel_instance = debug_panel.instantiate()
	add_child(debug_panel_instance)

func load_state_label() -> void:
	state_label_instance = state_label.instantiate()
	add_child(state_label_instance)

func _process(delta) -> void:
	if Input.is_action_just_pressed("debug"):
		if visible:
			print("bruh")
			visible = false
		else:
			visible = true
	if Global.player != null:
		debug_panel_instance.floor_label.text = "true" if Global.player.is_on_floor() else "false"
		debug_panel_instance.wall_label.text = "true" if Global.player.is_on_wall() else "false"
		debug_panel_instance.ceiling_label.text = "true" if Global.player.is_on_ceiling() else "false"

func _exit_tree() -> void:
	Global.debug = null

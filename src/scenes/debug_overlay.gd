extends Control

@export var state_label : PackedScene
@onready var state_label_instance : Control = null
@export var debug_panel : Control

func _ready() -> void:
	Events.player_ready.connect(_on_player_ready)
	Events.player_exit.connect(_on_player_exit)

func _on_player_ready(player: Player) -> void:
	state_label_instance = state_label.instantiate()
	player.add_child(state_label_instance)

func _on_player_exit(player: Player) -> void:
	state_label = null

func _process(delta) -> void:
	if Input.is_action_just_pressed("debug"):
		if visible:
			print("bruh")
			visible = false
		else:
			visible = true
	if Global.player != null:
		debug_panel.floor_label.text = "true" if Global.player.is_on_floor() else "false"
		debug_panel.wall_label.text = "true" if Global.player.is_on_wall() else "false"
		debug_panel.ceiling_label.text = "true" if Global.player.is_on_ceiling() else "false"

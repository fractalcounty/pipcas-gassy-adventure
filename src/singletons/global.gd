extends Node

var player = null

var camera : Camera2D = null
var remote_transform : RemoteTransform2D = null
var skin : Sprite2D = null
var subviewport_container = null
var subviewport = null
var viewport_camera : Camera2D = null
var mouse_moving = false
var joy_moving = false
var cutscene_focus : Node2D
var focus : Node2D
var cutscene_active : bool = false
var debug2 : Control = null
var is_grounded : bool
var game_scene : Node = null
var effects : Node2D = null
var debug_overlay : Control = null

var level : Node2D = null

var debug : Control = null

var counter : Control = null

enum state {INTRO, MENU, GAME, PAUSE, CUTSCENE}

var game_state: state = state.INTRO:
	set(value):
		print("[game] Gamestate changed to ", value, " (", state.keys()[value], ")")
		game_state = value

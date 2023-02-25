extends Node

var pipca = null
var pipca_origin : Marker2D = null
var camera : Camera2D = null
var remote_transform : RemoteTransform2D = null
var skin : Sprite2D = null
var viewport_container = null
var viewport = null
var viewport_camera : Camera2D = null
var mouse_moving = false
var joy_moving = false
var cutscene_focus : Node2D
var focus : Node2D
var cutscene_active : bool = false
var debug : Control = null
var debug2 : Control = null
var is_grounded : bool
var game_scene : Node

enum state {INTRO, MENU, GAME, PAUSE, CUTSCENE}

var game_state: state = state.INTRO:
	set(value):
		#prints("Game state changed to", value, "a.k.a", state.keys()[value])
		game_state = value

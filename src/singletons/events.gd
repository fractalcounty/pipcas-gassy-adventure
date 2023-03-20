extends Node

signal belched(mouthpos, dir)
signal follow_origin(origin_pos)

# Cutscenes
signal cutscene_start
signal cutscene_end
signal cutscene_reset

signal flash_banner(banner_title, banner_subtitle)

signal player_spawned(player)

signal pause_opened
signal pause_closed

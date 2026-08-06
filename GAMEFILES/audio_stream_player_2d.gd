extends AudioStreamPlayer2D
@onready var player = self
var main_menu = preload("res://music/cool_one_run_theme.mp3")
var main_menu_alt = preload("res://music/after_all_alters_break.mp3")
func _ready():
	play_main()
func play_main():
	player.stream = main_menu
	player.play()
func play_alt():
	player.stream = main_menu_alt
	player.play()
func switch_track(new_stream):
	player.stop()
	player.stream = new_stream
	player.play()

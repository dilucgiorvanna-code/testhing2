extends Button
const SETTINGS_PATH := "user://settings.cfg"
var music_enabled := true
func _ready():
	pressed.connect(_on_pressed)
	load_settings()
	apply_music_setting()
	update_text()
func _on_pressed():
	music_enabled = !music_enabled
	apply_music_setting()
	update_text()
	save_settings()
func apply_music_setting():
	var music_bus := AudioServer.get_bus_index("Music")
	if music_bus != -1:
		AudioServer.set_bus_mute(music_bus, !music_enabled)
	else:
		push_warning("Music bus not found.")
func update_text():
	if music_enabled:
		text = "Music ON"
	else:
		text = "Music OFF"
func save_settings():
	var config := ConfigFile.new()
	config.set_value("Audio", "MusicEnabled", music_enabled)
	var err := config.save(SETTINGS_PATH)
	if err != OK:
		push_error("Couldn't save settings.")
func load_settings():
	var config := ConfigFile.new()
	if config.load(SETTINGS_PATH) == OK:
		music_enabled = config.get_value("Audio", "MusicEnabled", true)
	else:
		music_enabled = true

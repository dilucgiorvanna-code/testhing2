extends Node

const SAVE_PATH = "user://settings.save"

var music_volume: float = 1.0
var sfx_volume: float = 1.0
var voice_volume: float = 1.0
var brightness: float = 1.0

var music_enabled := true
var sfx_enabled := true
var voice_enabled := true


func _ready():
	load_settings()
	apply_audio_settings()


func save_settings():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)

	var data = {
		"music_volume": music_volume,
		"sfx_volume": sfx_volume,
		"voice_volume": voice_volume,
		"brightness": brightness,

		"music_enabled": music_enabled,
		"sfx_enabled": sfx_enabled,
		"voice_enabled": voice_enabled
	}

	file.store_var(data)


func load_settings():

	if !FileAccess.file_exists(SAVE_PATH):
		save_settings()
		return


	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = file.get_var()


	music_volume = data.get("music_volume", 1.0)
	sfx_volume = data.get("sfx_volume", 1.0)
	voice_volume = data.get("voice_volume", 1.0)
	brightness = data.get("brightness", 1.0)

	music_enabled = data.get("music_enabled", true)
	sfx_enabled = data.get("sfx_enabled", true)
	voice_enabled = data.get("voice_enabled", true)



func apply_audio_settings():

	set_bus_volume(
		"Music",
		music_volume,
		music_enabled
	)

	set_bus_volume(
		"Voice",
		voice_volume,
		voice_enabled
	)

	set_bus_volume(
		"SFX",
		sfx_volume,
		sfx_enabled
	)



func set_bus_volume(bus_name:String, volume:float, enabled:bool):

	var bus = AudioServer.get_bus_index(bus_name)

	if bus == -1:
		print("Missing audio bus: ", bus_name)
		return


	if enabled:
		AudioServer.set_bus_volume_db(
			bus,
			linear_to_db(volume)
		)
	else:
		AudioServer.set_bus_volume_db(
			bus,
			-80
		)



func set_music_volume(value:float):

	music_volume = value
	apply_audio_settings()
	save_settings()



func set_sfx_volume(value:float):

	sfx_volume = value
	apply_audio_settings()
	save_settings()



func set_voice_volume(value:float):

	voice_volume = value
	apply_audio_settings()
	save_settings()



func toggle_music(value:bool):

	music_enabled = value
	apply_audio_settings()
	save_settings()



func toggle_sfx(value:bool):

	sfx_enabled = value
	apply_audio_settings()
	save_settings()



func toggle_voice(value:bool):

	voice_enabled = value
	apply_audio_settings()
	save_settings()

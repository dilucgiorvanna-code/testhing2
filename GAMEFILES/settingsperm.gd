extends Control

@onready var music = $MusicSlider
@onready var sfx = $SFX
@onready var voice = $VL
@onready var bright = $BRIGHTNESS
@onready var back = $back


@onready var music_check = $Musiccheckperm/Musiccheckperm2
@onready var sfx_check = $SOUNDEFFECTSCHECK/SFXCHECKMARK
@onready var voice_check = $VOICELINESCHECK/VLCHECKMARK


func _ready():
	
	
	music.value = Settings.music_volume
	sfx.value = Settings.sfx_volume
	voice.value = Settings.voice_volume
	bright.value = Settings.brightness

	music_check.visible = Settings.music_enabled
	sfx_check.visible = Settings.sfx_enabled
	voice_check.visible = Settings.voice_enabled

	if Settings.music_enabled:
		_apply_music_volume(Settings.music_volume)
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -80)

	if Settings.sfx_enabled:
		_apply_sfx_volume(Settings.sfx_volume)
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sfx"), -80)

	if Settings.voice_enabled:
		_apply_voice_volume(Settings.voice_volume)
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("VL"), -80)

	music.value_changed.connect(_music_changed)
	sfx.value_changed.connect(_sfx_changed)
	voice.value_changed.connect(_voice_changed)
	bright.value_changed.connect(_brightness_changed)
	back.pressed.connect(_on_back_pressed)
	back.text = "Back"


func _music_changed(value):
	Settings.music_volume = value

	if Settings.music_enabled:
		_apply_music_volume(value)

	Settings.save_settings()


func _sfx_changed(value):
	Settings.sfx_volume = value

	if Settings.sfx_enabled:
		_apply_sfx_volume(value)

	Settings.save_settings()


func _voice_changed(value):
	Settings.voice_volume = value

	if Settings.voice_enabled:
		_apply_voice_volume(value)

	Settings.save_settings()


func _brightness_changed(value):
	Settings.brightness = value
	Settings.save_settings()


func _apply_music_volume(value):
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"),
		linear_to_db(value)
	)


func _apply_sfx_volume(value):
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Sfx"),
		linear_to_db(value)
	)


func _apply_voice_volume(value):
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("VL"),
		linear_to_db(value)
	)


func _on_musiccheckperm_pressed():
	Settings.music_enabled = !Settings.music_enabled

	music_check.visible = Settings.music_enabled

	if Settings.music_enabled:
		_apply_music_volume(Settings.music_volume)
	else:
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index("Music"),
			-80
		)

	Settings.save_settings()


func _on_sfxcheckmark_pressed():
	Settings.sfx_enabled = !Settings.sfx_enabled

	sfx_check.visible = Settings.sfx_enabled

	if Settings.sfx_enabled:
		_apply_sfx_volume(Settings.sfx_volume)
	else:
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index("Sfx"),
			-80
		)

	Settings.save_settings()


func _on_vlcheckmark_pressed():
	Settings.voice_enabled = !Settings.voice_enabled

	voice_check.visible = Settings.voice_enabled

	if Settings.voice_enabled:
		_apply_voice_volume(Settings.voice_volume)
	else:
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index("VL"),
			-80
		)

	Settings.save_settings()


func _on_back_pressed():
	get_tree().change_scene_to_file("res://menus/mainmenu.tscn")

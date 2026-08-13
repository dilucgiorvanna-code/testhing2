extends Control
@onready var AIN = $Ain3
@onready var player = $AudioStreamPlayer2D
var tracks: Array[AudioStream] = []
var queue: Array[AudioStream] = []
var music_enabled = true
func _ready():
	tracks = [
		preload("res://music/At_The_Ravens_door_Main_Menu_theme_of_Avery_Must_Die.mp3"),
	]
	player.finished.connect(_play_next)
	_reshuffle()
	_play_next()
	AIN.modulate = Color(0.1, 0.05, 0.05, 0.2)
	await get_tree().create_timer(2.0).timeout
	var tween = create_tween()
	tween.tween_property(
		AIN,
		"modulate",
		Color(1.0, 1.0, 1.0, 1.0),
		3.0
	)
func _reshuffle():
	queue = tracks.duplicate()
	queue.shuffle()
func _play_next():
	if !music_enabled:
		return
	if queue.is_empty():
		_reshuffle()
	var next_track = queue.pop_front()
	if next_track == null:
		return
	player.stop()
	player.stream = next_track
	player.play()
func _on_lg_pressed():
	music_enabled = !music_enabled
	if music_enabled:
		_play_next()
	else:
		player.stop()

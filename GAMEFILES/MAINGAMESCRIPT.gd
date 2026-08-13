extends Node
const TOTAL_ALTARS := 5
var altars_broken := 0
var event_started := false
var portal_spawned := false
@onready var world_clock = $WORLDCLOCK
@onready var argent = $AudioStreamPlayer
@onready var portal = $Portal
func _ready():
	world_clock.timeout.connect(_on_world_clock_timeout)
	world_clock.wait_time = 120.0
	world_clock.one_shot = true
	portal.visible = false
	argent.stream = preload("res://music/argent.mp3")
func altar_broken():
	if event_started:
		return
	altars_broken += 1
	print("Altars:", altars_broken, "/", TOTAL_ALTARS)
	if altars_broken >= TOTAL_ALTARS:
		event_started = true
		argent.play()
		world_clock.start()
func _process(_delta):
	if event_started and !portal_spawned:
		if world_clock.time_left <= 60.0:
			portal_spawned = true
			portal.spawn()
			print("Portal spawned!")
func _on_world_clock_timeout():
	portal.despawn()
#portal makes you win
#this is where all main game files go, like the altars handling ect. press f or "destroy" (check project> project settings> input map> and you'll see the name
#alter has to be held for 7 seconds to despan "res://meshes/alter.tscn" is the file. it goes down by 10% of it's max every second when not held
#remember that I will be doing scripting too

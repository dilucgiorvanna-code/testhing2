extends Node

var total_altars := 0
var altars_broken := 0

var event_started := false
var portal_spawned := false

var world_clock
var portal
var argent


func register_world(world):
	world_clock = world.get_node("WORLDCLOCK")
	portal = world.get_node("Portal")
	argent = world.get_node("AudioStreamPlayer")

	total_altars = world.get_tree().get_nodes_in_group("altar").size()

	altars_broken = 0
	event_started = false
	portal_spawned = false

	portal.visible = false

	argent.stream = preload("res://NEWSTUFF/argent.mp3")

	world_clock.wait_time = 120.0
	world_clock.one_shot = true

	world_clock.timeout.connect(_on_world_clock_timeout)

	print("Altars found:", total_altars)


func altar_broken():
	if event_started:
		return

	altars_broken += 1

	print("Altars:", altars_broken, "/", total_altars)

	if altars_broken >= total_altars:
		start_event()


func start_event():
	event_started = true

	argent.play()
	world_clock.start()


func _process(_delta):
	if event_started and !portal_spawned:
		if world_clock.time_left <= 60:
			portal_spawned = true
			portal.spawn()


func _on_world_clock_timeout():
	portal.despawn()

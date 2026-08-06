extends Node3D

@export var max_bullets: int = 10
var bullets: int = 10

var shooting := false
var sliding := false

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var shotgun_sfx: AudioStreamPlayer = $"../Shotgun"


func _ready():
	bullets = max_bullets
	anim.play("NOSHOOT")


func _process(_delta):
	if sliding:
		return

	if Input.is_action_pressed("shoot"):
		shoot()
	else:
		if !shooting and anim.current_animation != "NOSHOOT":
			anim.play("NOSHOOT")


func shoot():
	if shooting:
		return

	if bullets <= 0:
		return

	shooting = true
	bullets -= 1

	anim.play("shoot")
	shotgun_sfx.play()

	await anim.animation_finished

	shooting = false

	if !sliding:
		anim.play("NOSHOOT")


func reload():
	if shooting:
		return

	if bullets == max_bullets:
		return

	shooting = true

	anim.play("shoot")

	await anim.animation_finished

	bullets = max_bullets

	shooting = false

	if !sliding:
		anim.play("NOSHOOT")


func slide():
	if sliding:
		return

	sliding = true

	anim.play("slide")

	await anim.animation_finished

	sliding = false

	if !shooting:
		anim.play("NOSHOOT")

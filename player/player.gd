
extends CharacterBody3D
#there are perks that can increase stats, so please make it to where everything is locked into a certain stat. ex, if you have hp set permanently to 100, and I have a 50% more hp perk. 
#sliding must be really fast and it should glitch $Camera3D slightly
@export var speed := 150.0
@export var jump_velocity := 20.0
@export var mouse_sensitivity := 0.002
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 8
@onready var camera: Camera3D = $Camera3D
var rotation_x := 0.0
@onready var hp_bar: TextureProgressBar = $hp
@onready var bullet_label: TextureProgressBar = $"../bullets"
@onready var damage_overlay: TextureRect = $"../DamageOverlay"
@export var gun: Node3D
@export var magazine_size := 12
@export var reserve_ammo := 72
var ammo := 12
var can_shoot := true
var reloading := false
@export var max_hp := 100
var hp := 100
const LOW_HP = [
	preload("res://pictures/Untitled234.webp"),
	preload("res://pictures/Untitled234_20260625135942.webp"),
	preload("res://pictures/Untitled234_20260625135947.webp"),
	preload("res://pictures/Untitled234_20260625135951.webp"),
	preload("res://pictures/Untitled234_20260625135956.webp"),
	preload("res://pictures/Untitled234_20260625140000.webp"),
	preload("res://pictures/Untitled234_20260625140004.webp"),
	preload("res://pictures/Untitled234_20260625140007.webp"),
	preload("res://pictures/Untitled234_20260625140011.webp"),
	preload("res://pictures/Untitled234_20260625140016.webp"),
	preload("res://pictures/Untitled234_20260625140020.webp"),
	preload("res://pictures/Untitled234_20260625140423.webp"),
	preload("res://pictures/Untitled234_20260625140439.webp"),
	preload("res://pictures/Untitled234_20260625140447.webp"),
	preload("res://pictures/Untitled234_20260625140453.webp"),
	preload("res://pictures/Untitled234_20260625141237.webp"),
	preload("res://pictures/Untitled234_20260625141252.webp"),
	preload("res://pictures/Untitled234_20260625141309.webp")
]
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_update_hp()
	_update_ammo()
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		rotation_x -= event.relative.y * mouse_sensitivity
		rotation_x = clamp(rotation_x, deg_to_rad(-80), deg_to_rad(80))
		camera.rotation.x = rotation_x
	if Input.is_action_just_pressed("shoot"):
		shoot()
	if Input.is_action_just_pressed("reload"):
		reload()
func _physics_process(delta):
	if !is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	var input_dir = Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_back"
	)
	var direction = (transform.basis * Vector3(
		input_dir.x,
		0,
		input_dir.y
	)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x,0,speed)
		velocity.z = move_toward(velocity.z,0,speed)
	move_and_slide()
	_update_damage_overlay()
func shoot():
	if !can_shoot:
		return
	if reloading:
		return
	if ammo <= 0:
		reload()
		return
	ammo -= 1
	_update_ammo()
	if gun and gun.has_method("shoot"):
		gun.shoot()
func reload():
	if reloading:
		return
	if ammo == magazine_size:
		return
	if reserve_ammo <= 0:
		return
	reloading = true
	can_shoot = false
	if gun and gun.has_method("reload"):
		gun.reload()
	await get_tree().create_timer(40.0 / 60.0).timeout
	var needed = magazine_size - ammo
	var loaded = min(needed,reserve_ammo)
	ammo += loaded
	reserve_ammo -= loaded
	reloading = false
	can_shoot = true
	_update_ammo()
func damage(amount):
	hp -= amount
	hp = clamp(hp,0,max_hp)
	_update_hp()
	if hp <= 0:
		die()
func heal(amount):
	hp += amount
	hp = clamp(hp,0,max_hp)
	_update_hp()
func _update_hp():
	hp_bar.max_value = max_hp
	hp_bar.value = hp
func _update_ammo():
	bullet_label.text = str(ammo) + "/" + str(reserve_ammo)
func _update_damage_overlay():
	if hp <= max_hp * 0.5:
		damage_overlay.visible = true
		var frame = int(Time.get_ticks_msec()/70.0) % LOW_HP.size()
		damage_overlay.texture = LOW_HP[frame]
	else:
		damage_overlay.visible = false
func die():
	print("Player died")
#$"../shotgunSELFLESS"
#player starts with 10 bullets, needs one to shoot. only shoots one at a time. play animation called "NOSHOOT" when not shooting. play "SHOOTING" when "shoot", an input action is pressed. (right mouse button is linked to shoot"")

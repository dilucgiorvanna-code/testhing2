extends CharacterBody3D
@export var hp: int = 100
@export var max_hp: int = 100
@export var speed := 10.0
@export var slide_speed := 20.0
@export var slide_duration := 0.8
@export var slide_rotation := -20.0
@export var slide_acceleration := 15.0
@export var gravity := 20.0
@export var mouse_sensitivity := 0.002
@onready var shotgun = $Camera3D/shotgunSELFLESS
@onready var camera: Camera3D = $Camera3D
@onready var hp_bar: TextureProgressBar = $CanvasLayer/TextureProgressBar
@onready var walking_sfx: AudioStreamPlayer = $"WalkingsfxSelfless(1)"
var sliding := false
var move_dir := Vector3.ZERO
var camera_x_rotation := 0.0
var slide_velocity := Vector3.ZERO
var normal_rotation := 0.0
func _ready():
	hp_bar.max_value = max_hp
	update_hp()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera_x_rotation -= event.relative.y * mouse_sensitivity
		camera_x_rotation = clamp(camera_x_rotation, -1.5, 1.5)
		camera.rotation.x = camera_x_rotation
func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		if velocity.y < 0:
			velocity.y = -1
	var input := Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_back"
	)
	var cam_forward = -camera.global_transform.basis.z
	var cam_right = camera.global_transform.basis.x
	cam_forward.y = 0
	cam_right.y = 0
	cam_forward = cam_forward.normalized()
	cam_right = cam_right.normalized()
	move_dir = (
		cam_right * input.x -
		cam_forward * input.y
	).normalized()
	if sliding:
		velocity.x = slide_velocity.x
		velocity.z = slide_velocity.z
		rotation.z = lerp(
			rotation.z,
			deg_to_rad(slide_rotation),
			slide_acceleration * delta
		)
	else:
		velocity.x = move_dir.x * speed
		velocity.z = move_dir.z * speed
		rotation.z = lerp(
			rotation.z,
			normal_rotation,
			slide_acceleration * delta
		)
	move_and_slide()
	handle_running_sound()
func _process(_delta):
	update_hp()
	if Input.is_action_pressed("shoot"):
		shotgun.shoot()
	if Input.is_action_just_pressed("reload"):
		shotgun.reload()
	if Input.is_action_just_pressed("slide"):
		start_slide()
func start_slide():
	if sliding:
		return
	sliding = true
	normal_rotation = rotation.z
	if move_dir.length() > 0.1:
		slide_velocity = move_dir * slide_speed
	else:
		var forward = -camera.global_transform.basis.z
		forward.y = 0
		slide_velocity = forward.normalized() * slide_speed
	shotgun.slide()
	await get_tree().create_timer(slide_duration).timeout
	sliding = false
	slide_velocity = Vector3.ZERO
func update_hp():
	hp_bar.value = hp
func take_damage(amount: int):
	hp = clamp(hp - amount, 0, max_hp)
	update_hp()
func heal(amount: int):
	hp = clamp(hp + amount, 0, max_hp)
	update_hp()
func handle_running_sound():
	var horizontal_velocity = Vector3(
		velocity.x,
		0,
		velocity.z
	)
	if horizontal_velocity.length() > 0.1 and is_on_floor():
		if !walking_sfx.playing:
			walking_sfx.play()
	else:
		if walking_sfx.playing:
			walking_sfx.stop()

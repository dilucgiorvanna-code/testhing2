extends CharacterBody3D
@export var speed := 3.0
@export var target: Node3D
@onready var nav_agent: NavigationAgent3D = $"../NavigationAgent3D"
@onready var ray: RayCast3D = $"../RayCast3D"
func _ready():
	nav_agent.path_desired_distance = 0.5
	nav_agent.target_desired_distance = 1.5
	ray.enabled = true
func _physics_process(delta):
	if target == null:
		return
	ray.target_position = to_local(target.global_position)
	if ray.is_colliding():
		var collider = ray.get_collider()
		if collider == target:
			chase_player()
		else:
			move_to_player()
	else:
		move_to_player()
	move_and_slide()
func move_to_player():
	nav_agent.target_position = target.global_position
	var next_position = nav_agent.get_next_path_position()
	var direction = next_position - global_position
	direction.y = 0
	if direction.length() > 0.1:
		direction = direction.normalized()
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
func chase_player():
	var direction = target.global_position - global_position
	direction.y = 0
	direction = direction.normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

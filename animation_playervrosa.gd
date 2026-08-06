extends AnimationPlayer
@onready var attacks: Area3D = $"../attacks"
@onready var p2attackandheavy2: Area3D = $"../p2attackandheavy2"
@onready var p2heavyandjump: Area3D = $"../p2heavyandjump"
func _ready():
	disable_all_hitboxes()
func _process(_delta):
	disable_all_hitboxes()
	var anim_name := String(current_animation)
	var time := current_animation_position
	match anim_name:
		"attack":
			if time >= 0.35 and time <= 0.55:
				attacks.monitoring = true
		"attack2":
			if time >= 0.45 and time <= 0.65:
				attacks.monitoring = true
		"P2attack":
			if time >= 0.40 and time <= 0.60:
				p2attackandheavy2.monitoring = true
		"p2heavy":
			if time >= 0.55 and time <= 0.80:
				p2attackandheavy2.monitoring = true
		"p2heavy_2":
			if time >= 0.60 and time <= 0.85:
				p2heavyandjump.monitoring = true
		"p2jump":
			if time >= 0.70 and time <= 0.90:
				p2heavyandjump.monitoring = true
func disable_all_hitboxes():
	attacks.monitoring = false
	p2attackandheavy2.monitoring = false
	p2heavyandjump.monitoring = false

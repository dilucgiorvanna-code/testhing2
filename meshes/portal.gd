extends Node3D
@onready var animation_player = $AnimationPlayer
func _ready():
	visible = false
	animation_player.play("portalanim")
	animation_player.get_animation("portalanim").loop_mode = Animation.LOOP_LINEAR
	animation_player.stop()
func spawn():
	visible = true
	animation_player.play("portalanim")
func despawn():
	animation_player.stop()
	visible = false

extends Area3D
@export var damage := 25
func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)

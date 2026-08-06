extends Area3D
@export var hp := 100
func take_damage(amount:int):
	hp -= amount
	print("Enemy took ", amount, " damage")
	if hp <= 0:
		die()
func die():
	get_parent().queue_free()

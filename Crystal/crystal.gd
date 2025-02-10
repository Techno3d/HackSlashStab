extends StaticBody2D
class_name Crystal

@export var health: float = 100

func damage_crystal(num: float):
	health -= num
	if health <= 0:
		queue_free()

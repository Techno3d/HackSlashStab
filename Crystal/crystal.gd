extends StaticBody2D
class_name Crystal

@export var health: float = 100
@onready var health_bar: ProgressBar = $HealthBar

func _ready():
	health_bar.max_value = health
	health_bar.value = health

func damage_crystal(num: float):
	health -= num
	health_bar.value = health
	if health <= 0:
		queue_free()

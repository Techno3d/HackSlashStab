extends RigidBody2D

var health: float = 40

func _ready():
	linear_velocity = Vector2.RIGHT*400
	pass 

func damage(num: float):
	health -= num
	print("a")
	if(health <= 0):
		queue_free()

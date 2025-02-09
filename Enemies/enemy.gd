extends RigidBody2D
class_name Enemy

signal enemy_died

var health: float = 40
var damage_taken = 0;
var hits: int = 0
var isComboing: bool = false

func _ready():
	linear_velocity = Vector2.RIGHT*400
	pass 

func damage(num: float):
	if !isComboing:
		isComboing = true
		get_tree().create_timer(0.3).timeout.connect(func(): 
			health -= damage_taken
			isComboing = false
			hits = 0
			damage_taken = 0
		)
	hits += 1
	damage_taken += num*hits
	print("combo damage %f with modifier %d for a total of %f" % [num, hits, damage_taken])
	if(health <= 0):
		queue_free()

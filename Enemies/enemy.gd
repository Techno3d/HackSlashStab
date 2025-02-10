extends RigidBody2D
class_name Enemy

signal enemy_died

var health: float = 40
var damage_taken = 0;
var hits: int = 0
var isComboing: bool = false

@export var attack_str: float = 5
@onready var timer: Timer = $Timer
@onready var attack_area: Area2D = $Area2D
var is_attacking: bool = false
var nearby_crystal: Crystal
var state: EnemyState = EnemyState.TowardsCrystal

func _ready():
	linear_velocity = Vector2.RIGHT*400
	attack_area.body_entered.connect(func(body):
		if body is Crystal:
			is_attacking = true
			nearby_crystal = body
		if body is Enemy && body != self:
			state = EnemyState.UnCrowd
			linear_velocity = linear_velocity.rotated(randf_range(-PI/2, PI/2))
			get_tree().create_timer(1).timeout.connect(func(): state = EnemyState.TowardsCrystal)
	)
	attack_area.body_exited.connect(func(body):
		if body is Crystal:
			is_attacking = false
	)
	timer.timeout.connect(attack)

func _physics_process(_delta):
	var nearest: Crystal = find_nearest()
	if nearest == null:
		return
	match state:
		EnemyState.TowardsCrystal:
			linear_velocity = (nearest.position - position).normalized() * 400
		EnemyState.UnCrowd:
			pass
			# print("hi")

func find_nearest() -> Crystal:
	var nearest: Crystal = get_tree().get_first_node_in_group("Crystals")
	if nearest == null:
		return null
	for crystal: Crystal in get_tree().get_nodes_in_group("Crystals"):
		if nearest.position.distance_squared_to(position) > crystal.position.distance_squared_to(position):
			nearest = crystal		
	return nearest

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
	# print("combo damage %f with modifier %d for a total of %f" % [num, hits, damage_taken])
	if(health <= 0):
		enemy_died.emit()
		queue_free()

func attack():
	if !is_attacking:
		return
	nearby_crystal.damage_crystal(attack_str)

enum EnemyState {
	TowardsCrystal, UnCrowd
}
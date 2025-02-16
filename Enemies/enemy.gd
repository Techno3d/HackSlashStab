extends AnimatableBody2D
class_name Enemy

signal enemy_died

var vel: Vector2 = Vector2.ZERO

var health: float = 40
var damage_taken = 0;
var hits: int = 0
var isComboing: bool = false

@export var attack_str: float = 5
@onready var timer: Timer = $Timer
@onready var attack_area: Area2D = $Area2D
var is_attacking: bool = false
var nearby_crystal: Crystal

func _ready():
	vel = Vector2.RIGHT*400
	attack_area.body_entered.connect(func(body):
		if body is Crystal:
			is_attacking = true
			nearby_crystal = body
	)
	attack_area.body_exited.connect(func(body):
		if body is Crystal:
			is_attacking = false
	)
	timer.timeout.connect(attack)

func _physics_process(delta):
	# Rotation Start
	var mag = vel.length()

	var nearest: Crystal = find_nearest()
	var flock: Array[Enemy] = find_nearby_enemies()
	seperation(flock)
	alignment(flock)
	cohession(flock)

	if nearest != null:
		vel += (nearest.position-position)*0.05

	vel = vel.normalized()*mag
	# Rotation End

	# Lets move
	var collision: KinematicCollision2D = move_and_collide(vel*delta)
	if collision:
		vel = vel.bounce(collision.get_normal())

func find_nearest() -> Crystal:
	var nearest: Crystal = get_tree().get_first_node_in_group("Crystals")
	var second_nearest: Crystal = get_tree().get_first_node_in_group("Crystals")

	if nearest == null:
		return null
	for crystal: Crystal in get_tree().get_nodes_in_group("Crystals"):
		if nearest.position.distance_squared_to(position) > crystal.position.distance_squared_to(position):
			second_nearest = nearest
			nearest = crystal		
	return nearest if randf_range(0,1) < 0.8 else second_nearest

func seperation(nearby_enemies: Array[Enemy]):
	var dv: Vector2 = Vector2(0,0)
	for enemy in nearby_enemies:
		if enemy.position.distance_squared_to(position) < 5625: # 75^2
			dv += position - enemy.position
	vel += dv*0.25
		

func alignment(nearby_enemies: Array[Enemy]):
	var avg_vel: Vector2 = Vector2(0,0)
	var count = 0
	for enemy in nearby_enemies:
		if enemy.position.distance_squared_to(position) > 5625: # 75^2
			avg_vel += enemy.vel
			count += 1
	if count <= 0:
		return
	avg_vel = avg_vel / count
	vel += (avg_vel-vel)*0.2

func cohession(nearby_enemies: Array[Enemy]):
	var avg_pos: Vector2 = Vector2(0,0)
	var count = 0
	for enemy in nearby_enemies:
		if enemy.position.distance_squared_to(position) > 5625: # 75^2
			avg_pos += enemy.position
			count += 1
	if count <= 0:
		return
	avg_pos = avg_pos / count
	vel += (avg_pos-position)*0.1 * (-2 if nearby_enemies.size()>=3 else 1)

func find_nearby_enemies() -> Array[Enemy]:
	var ret: Array[Enemy] = []
	for body in get_tree().get_nodes_in_group("Enemies"):
		if body is Enemy && body != self && (body as Enemy).position.distance_squared_to(position) < 40000: # 150^2
			ret.push_back(body as Enemy)
	return ret


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

extends Node2D

@export var max_num_enemies: int = 5
@export var wait_time: float = 2
var num_enemies: int = 0
var enemy_scene: PackedScene = preload("res://Enemies/enemy.tscn")

@onready var sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

func _ready():
	timer.timeout.connect(spawn)
	timer.wait_time = wait_time

func _process(delta):
	sprite.rotate(PI/2*delta)

func spawn():
	if num_enemies < max_num_enemies:
		var enemy: Enemy = enemy_scene.instantiate()
		enemy.enemy_died.connect(func(): 
			if randf_range(0, 1) > 0.7:
				position = Vector2(randf_range(0,1920),randf_range(0,1920))
		)
		num_enemies+=1
		enemy.position = position+Vector2(randf_range(-10, 10), randf_range(-10, 10))
		get_tree().root.add_child(enemy)
		enemy.vel = Vector2(randf_range(-4, 4)*100, randf_range(-4, 4)*100)
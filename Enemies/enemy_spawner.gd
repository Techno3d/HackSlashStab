extends Node2D

@export var max_num_enemies: int = 5
@export var time_limit: float = 2
var num_enemies: int = 0
var enemy_scene: PackedScene = preload("res://Enemies/enemy.tscn")
var time: float = 0

@onready var sprite: Sprite2D = $Sprite2D

func _ready():
	pass 

func _process(delta):
	sprite.rotate(PI/2*delta)
	time += delta
	if(time >= time_limit && num_enemies < max_num_enemies):
		var enemy: Enemy = enemy_scene.instantiate()
		enemy.enemy_died.connect(func(): 
			if randf_range(0, 1) > 0.7:
				position = Vector2(randf_range(0,1920),randf_range(0,1920))
		)
		time = 0
		num_enemies+=1
		enemy.position = position+Vector2(randf_range(-10, 10), randf_range(-10, 10))
		get_tree().root.add_child(enemy)
		enemy.vel = Vector2(randf_range(-4, 4)*100, randf_range(-4, 4)*100)

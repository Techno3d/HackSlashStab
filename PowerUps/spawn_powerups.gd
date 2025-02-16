extends Node2D

const MAX_NUM_POWERUPS: int = 100

@export var powerups: Array[EffectBase]
@onready var timer: Timer = $Timer

var base: PackedScene = preload("res://PowerUps/base_power_up.tscn")
var powerup_arr: Array[BasePowerup] = []

func _ready():
	timer.timeout.connect(spawn)

func _process(_delta):
	pass

func spawn():
	if powerup_arr.size() > MAX_NUM_POWERUPS:
		return
	var spawn_pos: Vector2 = Vector2(randf_range(0,1920), randf_range(0,1920))
	var spawning: BasePowerup = base.instantiate()
	spawning.position = spawn_pos
	spawning.effect = powerups.pick_random()
	powerup_arr.push_back(spawning)
	add_child(spawning)
	pass
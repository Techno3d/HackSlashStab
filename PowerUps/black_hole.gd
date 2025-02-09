extends EffectBase
class_name SpawnBlackHoleEffect

var black_hole_sprite = preload("res://PowerUps/black_hole.tscn")
@export var pull_time: float = 0.2

func effect(powerup: Node2D, position: Vector2, _normal: Vector2):
    var sprite = black_hole_sprite.instantiate()
    sprite.pull_time = pull_time
    sprite.position = position
    powerup.get_tree().root.add_child(sprite)
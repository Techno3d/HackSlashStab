extends EffectBase
class_name SlowTImeEffect

@export var length: float = 3.0
@export var time_scale: float = 0.4

func effect(powerup: Node2D, position: Vector2, normal: Vector2):
    Engine.time_scale = time_scale
    var timer = powerup.get_tree().create_timer(length)
    timer.timeout.connect(func():
        Engine.time_scale = 1.0    
    )

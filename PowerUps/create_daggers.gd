extends EffectBase
class_name CreateDaggerEffect

@export var spawnable_blades: Array[PackedScene]

func effect(powerup: Node2D, position: Vector2, normal: Vector2):
    call_deferred("add_blade", powerup, position, normal)

func add_blade(powerup: Node2D, position: Vector2, normal: Vector2):
    var blade_scene: PackedScene = spawnable_blades.pick_random()
    var new_blade: Node2D = blade_scene.instantiate()
    new_blade.position = position
    var angle = atan2(normal.y, normal.x)
    var vel_dir: Vector2
    vel_dir = Vector2(cos(angle-PI/4), sin(angle-PI/4))
    powerup.get_parent().add_child(new_blade)
    if new_blade.has_method("set_vel_dir"):
        new_blade.set_vel_dir(vel_dir)
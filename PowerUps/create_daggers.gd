extends EffectBase
class_name CreateDaggerEffect

@export var spawnable_blades: Array[PackedScene]

func effect(powerup: Node2D, position: Vector2, normal: Vector2):
    var blade_scene: PackedScene = spawnable_blades.pick_random()
    var new_blade: Node2D = blade_scene.instantiate()
    new_blade.position = position
    var angle = atan2(normal.y, normal.x)
    var vel_dir: Vector2
    if 0 < angle and angle <= PI/2:
        vel_dir = Vector2(cos(3*PI/4), sin(3*PI/4))
    elif PI/2 < angle and angle <= PI:
        vel_dir = Vector2(cos(5*PI/4), sin(5*PI/4))
    elif PI < angle and angle <= 3*PI/2:
        vel_dir = Vector2(cos(7*PI/4), sin(7*PI/4))
    elif 3*PI/2 < angle and angle < TAU:
        vel_dir = Vector2(cos(PI/4), sin(PI/4))
    if new_blade.has_method("set_vel_dir"):
        new_blade.set_vel_dir(vel_dir)
    powerup.get_parent().add_child(new_blade)

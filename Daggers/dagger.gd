extends AnimatableBody2D

@onready var sprite = $Sprite2D
@export var rotation_time: float = 0.5

var vel_dir: Vector2 = Vector2.ZERO
var speed: float = 1200.0
var decel: float = -10

func _physics_process(delta):
	speed -= decel*delta
	var collision = move_and_collide(vel_dir*speed*delta)
	if collision:
		vel_dir = vel_dir.bounce(collision.get_normal())
		set_sprite_angle()

func set_vel_dir(new_dir: Vector2):
	vel_dir = new_dir
	set_sprite_angle()

func set_sprite_angle():
	var angle = atan2(vel_dir.y, vel_dir.x)
	# set_deferred("rotation", angle)
	var tween: Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TransitionType.TRANS_EXPO)
	tween.tween_property(sprite, "rotation", PI/2.0+angle, rotation_time)

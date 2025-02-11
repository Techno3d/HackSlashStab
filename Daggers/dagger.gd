extends AnimatableBody2D
class_name Dagger

@onready var sprite = $Sprite2D
@export var rotation_time: float = 0.5
@export var damage: float = 5
@onready var enemy_detector: Area2D = $Area2D

var vel_dir: Vector2 = Vector2.ZERO
var speed: float = 1200.0
var decel: float = -10

func _ready():
	SignalBus.black_hole_spawned.connect(gravitation_pull)
	enemy_detector.body_entered.connect(deflect)

func _physics_process(delta):
	speed -= decel*delta
	if(speed <= 0):
		queue_free()
	var collision = move_and_collide(vel_dir*speed*delta)
	if collision:
		vel_dir = vel_dir.bounce(collision.get_normal())
		set_sprite_angle()
		if(collision.get_collider().has_method("damage")):
			collision.get_collider().damage(damage)
			move_and_collide(vel_dir*5);

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

func gravitation_pull(pos: Vector2, pull_time: float):
	var dist = (pos-position).length()
	var dir = (pos - position).normalized()
	vel_dir = vel_dir.lerp(dir, clampf(20.0/dist, 0, 1))
	set_sprite_angle()

func deflect(body: Node):
	if !(body is Enemy):
		return
	var dir: Vector2 = (body.position - position).normalized()
	vel_dir = dir
	set_sprite_angle()

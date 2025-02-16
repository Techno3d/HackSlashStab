class_name BasePowerup extends Sprite2D

@export var effect: EffectBase
@onready var collider: Area2D = $Area2D

func _ready():
	collider.body_entered.connect(handle_collision)

func handle_collision(body: Node2D):
	effect.effect(self, position, body.vel_dir)
	queue_free()

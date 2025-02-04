extends CharacterBody2D

@export var rotation_time: float = 0.5

var speed: float = 1200.0
var vel_dir: Vector2 = Vector2.ZERO
@onready var viewport: Viewport = get_tree().root.get_viewport()
@onready var sprite: Sprite2D = $DaggerSprite
@onready var pivot: Node2D = $Pivot

func _ready():
	viewport.size_changed.connect(func(): viewport = get_tree().root.get_viewport())
	pivot.visible = false;

func _unhandled_input(event):
	if event is InputEventMouseButton:
		var m_event: InputEventMouseButton = event as InputEventMouseButton
		if !m_event.pressed and m_event.button_index == MOUSE_BUTTON_LEFT:
			var direction: Vector2 = m_event.position - viewport.get_visible_rect().size/2.0
			vel_dir = direction.normalized()
			set_sprite_angle()

func _physics_process(delta):
	var collision: KinematicCollision2D = move_and_collide(vel_dir*speed*delta)
	if collision:
		vel_dir = vel_dir.bounce(collision.get_normal())
		set_sprite_angle()

func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		pivot.show()
		var dir = viewport.get_mouse_position() - viewport.get_visible_rect().size/2.0
		dir = dir.normalized()
		pivot.rotation = atan2(dir.y, dir.x)
	else:
		pivot.hide()

func set_sprite_angle():
	var angle = atan2(vel_dir.y, vel_dir.x)
	# set_deferred("rotation", angle)
	var tween: Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TransitionType.TRANS_EXPO)
	tween.tween_property(sprite, "rotation", PI/2.0+angle, rotation_time)
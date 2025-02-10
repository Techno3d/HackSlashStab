extends Dagger

@onready var raycast: RayCast2D = $Sprite2D/RayCast2D

var is_swinging: bool = false

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

	# Only run when we first see enemy
	# if !is_swinging && raycast.is_colliding():
	# 	is_swinging = true
	# 	var tween: Tween = get_tree().create_tween()
	# 	tween.set_ease(Tween.EASE_OUT)
	# 	tween.set_trans(Tween.TransitionType.TRANS_EXPO)
	# 	tween.set_parallel(false)
	# 	tween.tween_property(sprite, "rotation", sprite.rotation-10, rotation_time)
	# 	tween.tween_property(sprite, "rotation", sprite.rotation+20, rotation_time*2)
	# 	tween.tween_property(sprite, "rotation", sprite.rotation-10, rotation_time)
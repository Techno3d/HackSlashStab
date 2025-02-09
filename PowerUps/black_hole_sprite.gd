extends Sprite2D

var pull_time = 0

func _ready():
	get_tree().create_timer(pull_time).timeout.connect(queue_free)
	pass # Replace with function body.

func _process(delta):
	rotate(PI/2*delta)
	SignalBus.black_hole_spawned.emit(position, pull_time)

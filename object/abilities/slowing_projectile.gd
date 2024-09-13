extends Node2D

var target:Node2D
var velocity : Vector2
@export var speed :float
@export var duration : float




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(target):
		position += (target.position-position).normalized() * delta * speed
		if position.distance_to(target.position) < 20:
			target.immobalize(duration)
			queue_free()
	else:
		queue_free()
		
		


	
	
	






func _on_timer_timeout():
	queue_free() 

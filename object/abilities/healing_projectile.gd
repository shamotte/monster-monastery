extends Node2D

var target:Node2D
@export var speed :float
@export var healing : float



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += (target.position-position).normalized() * delta * speed
	if target != null:
		if position.distance_to(target.position) < 20:
			target.take_damage(- healing)
			queue_free()






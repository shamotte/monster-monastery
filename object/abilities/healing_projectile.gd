extends Node2D

var target:Node2D
@export var speed :float
@export var healing : float



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(target):
		position += (target.position-position).normalized() * delta * speed
		if position.distance_to(target.position) < 20:
			target.heal_unit(healing)
			queue_free()






extends Node2D

var target:Node2D
@export var speed :float
@export var healing : float

var ring_spawned : bool = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(target):
		position += (target.position-position).normalized() * delta * speed
		if position.distance_to(target.position) < 20:
			target.heal_unit(healing)
			spawn_ring()
	else:
		queue_free()
		
		

func spawn_ring():
	print("Ring2")
	ring_spawned = true
	$CollisionShape2D.disabled = true
	$Projectile.visible = false 
	$Ring.visible = true
	$AnimationPlayer.play("Idle")
	position = target.position
	$Timer.start()
	
	
	






func _on_timer_timeout():
	queue_free() 

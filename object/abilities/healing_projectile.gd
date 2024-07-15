extends Node2D

var target:Node2D
@export var speed :float
@export var healing : float

var ring_spawned : bool = false



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ring_spawned:
		if $Timer.time_left == 0:
			queue_free()
	else:
		position += (target.position-position).normalized() * delta * speed
		if target != null:
			if position.distance_to(target.position) < 20:
				target.heal_unit(healing)
				print("Ring1")
				spawn_ring()
				#queue_free()
	

func spawn_ring():
	print("Ring2")
	ring_spawned = true
	$CollisionShape2D.disabled = true
	$Projectile.visible = false 
	$Ring.visible = true
	$AnimationPlayer.play("Idle")
	position = target.position
	$Timer.start()





extends Area2D
var velocity : Vector2
var damage : float
var life_time : float

func _ready():
	life_time = 5


func _process(delta):
	%area.collision_mask = collision_mask
	position += velocity * delta
	life_time -= delta
	if life_time <= 0:
		queue_free()


func _on_body_entered(body):
	%part.emitting = true
	remove_child($CollisionShape2D)
	remove_child($Sprite2D)
	velocity = Vector2.ZERO
	
	for b in %area.get_overlapping_bodies():
		b.take_damage(damage)
		
	await %part.finished
	queue_free()
	
func set_damage(new_damage : float):
	damage = new_damage

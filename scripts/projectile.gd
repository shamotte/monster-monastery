extends Area2D
var velocity : Vector2
var damage : float
var life_time : float

func _ready():
	life_time = 5
	


func _process(delta):
	look_at(position + velocity)
	position += velocity * delta
	life_time -= delta
	if life_time <= 0:
		queue_free()


func _on_body_entered(body):
	body.take_damage(damage)
	queue_free()
	
func set_damage(new_damage : float):
	damage = new_damage

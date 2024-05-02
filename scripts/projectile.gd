extends Area2D
var velocity : Vector2


func _ready():
	pass 


func _process(delta):
	position += velocity * delta


func _on_body_entered(body):
	print(body.name) 

extends Area2D

@export var duration : float =  5
@export var damage : float = 1
@export var damage_interval :float = 0.5 
@onready var timer :Timer= $Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	$Body.play("Death")
	timer.wait_time = damage_interval
	await get_tree().create_timer(duration).timeout
	queue_free()

func deal_damage():
	for body in get_overlapping_bodies():
		print("dealing damage")
		body.take_damage(damage)



func _on_dead_timer_timeout():
	$Body.visible = false

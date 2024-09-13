extends Area2D

@export var duration : float =  1
@export var damage : float = 10
@export var damage_interval :float = 1
@onready var timer :Timer= $Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	%part.emitting = true
	timer.wait_time = damage_interval
	await get_tree().create_timer(duration).timeout
	queue_free()

func deal_damage():
	for body in get_overlapping_bodies():
		print("dealing damage")
		body.take_damage(damage)

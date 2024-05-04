class_name projectile_shooter
extends Ability
@export var cooldown= 5.0
@export var projectile:PackedScene
@export var speed : float = 1

var time_left = 0
func fight_process(delta):
	time_left -= delta
	if time_left <= 0:
		time_left = cooldown
		print("atacking")
		var proj: Area2D = projectile.instantiate()
		var direction = (ovner.target_global_position - ovner.global_position).normalized()
		proj.velocity = direction *speed
		proj.global_position = ovner.global_position
		ProjectileOverseeer.add_child(proj)
		
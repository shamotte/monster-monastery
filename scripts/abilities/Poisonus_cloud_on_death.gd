extends Ability
class_name CloudOnDeath
@export  var scene : PackedScene 



func on_death():
	var instance : Area2D = scene.instantiate()
	instance.collision_mask = to_target
	instance.global_position = ovner.global_position
	ProjectileOverseeer.add_child(instance)

extends Ability
class_name SpawnOnDeath
@export  var type : UnitResource
@export var count : int = 1
@export var spawn_range : int = 30

var instance : PackedScene
func init(caster):
	instance = preload("res://object/unit.tscn")

func on_death():
	
	var i :Unit = instance.instantiate()
	i.type = type
	i.global_position = ovner.global_position + Vector2(randf_range(-1,1),randf_range(-1,1))* spawn_range
	ProjectileOverseeer.get_node("../Game").unit_holder.add_child(i)


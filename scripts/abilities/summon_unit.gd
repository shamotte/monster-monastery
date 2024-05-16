class_name  SummonUnit
extends Ability
@export var  cooldown : float= 3
@export var type : UnitResource
var time_left :float  = 0
var range = 100

var instance : PackedScene
func init():
	time_left = cooldown
	instance = preload("res://object/unit.tscn")

func process(delta):
	time_left -= delta
	if time_left <=0:
		time_left = cooldown
		var i :Unit = instance.instantiate()
		i.type = type
		i.global_position = ovner.global_position
		ProjectileOverseeer.get_node("../Game").unit_holder.add_child(i)
	

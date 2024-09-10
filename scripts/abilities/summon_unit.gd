class_name  SummonUnit
extends Ability
@export var  cooldown : float= 3
@export var type : UnitResource
var time_left :float  = 0
var range = 100
@export var summon_range : int = 30
@export var max_summons : int = 1
@export var summon_duration : float  = 10

@export var should_despawn : bool = true


var instance : PackedScene
func init(caster):
	time_left = cooldown
	instance = preload("res://object/unit.tscn")

var spawned_units = 0
func process(delta):
	time_left -= delta
	if time_left <=0:
		if spawned_units < max_summons:
			spawned_units += 1
			time_left = cooldown
			var i :Unit = instance.instantiate()
			i.type = type
			i.unit_died.connect(unit_died,CONNECT_ONE_SHOT)
			i.global_position = ovner.global_position + Vector2(randf_range(-1,1),randf_range(-1,1))* summon_range
			ProjectileOverseeer.get_node("../Game").unit_holder.add_child(i)
			if should_despawn:
				await ovner.get_tree().create_timer(summon_duration).timeout
				if is_instance_valid(i):
					i.queue_free()
			
	
func unit_died():
	spawned_units -= 1 

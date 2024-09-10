class_name LifeRip
extends Ability
@export var  cooldown : float
@export var visual_effect :PackedScene
@export_range(0,1) var  heal_ratio  :float= 1
@export var damage: float = 10
@export var range:float = 30;
var time_left = 0
var effect : Node2D
func init(context):
	effect = visual_effect.instantiate()
	context.add_child(effect)
	
func fight_process(delta):
	if is_instance_valid(ovner.target):
			if ovner.global_position.distance_to(ovner.target_global_position) < range:
				effect.get_node("particles").target = ovner.target
	
	time_left -= delta
	if time_left <= 0:
		if is_instance_valid(ovner.target):
			if ovner.global_position.distance_to(ovner.target_global_position) < range:
				time_left = cooldown
				var damage_dealt :int = ovner.target.take_damage(damage)
				ovner.heal_unit(damage_dealt * heal_ratio)



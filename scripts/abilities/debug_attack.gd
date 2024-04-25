class_name debug_attack
extends Ability

@export var interval:float
var time_left = interval
func fight_process(delta):
	time_left -=delta
	if time_left <= 0:
		time_left = interval
		print(ovner.name + "attacked")

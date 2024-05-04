class_name PriorityTable
extends Resource
var table : Array[int]
var color : Color
	
	
func get_priority(action_type: Priorities.ACTIONTYPES):
	return table[action_type]

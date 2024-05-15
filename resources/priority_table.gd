class_name PriorityTable
extends Resource
var id : int			#Id of group
var table : Array[int]
var color : Color
const MAXVALUE = 4
	
	
func get_priority(action_type: Priorities.ACTIONTYPES):
	return table[action_type]
	
func set_priority(action_type: Priorities.ACTIONTYPES,new_priority):
	if new_priority > MAXVALUE:
		new_priority %= (MAXVALUE + 1)
	table[action_type] = new_priority

func set_priority_array(_table : Array[int] = [1,1,1]):
	table = _table.duplicate(false)


func increment_priority(action_type: Priorities.ACTIONTYPES):
	table[action_type]+=1
	if table[action_type] > MAXVALUE:
		table[action_type] = 0

func decrement_priority(action_type: Priorities.ACTIONTYPES):
	table[action_type]-=1
	if table[action_type] < 0:
		table[action_type] = MAXVALUE

func clone():
	return PriorityTable.new(table,color)


func change_color(_color : Color):
	color = _color


func _init(_table : Array[int] = [1,1,1], _color : Color = Color.WHITE):
	table = _table.duplicate(false)
	color = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1))
	#color = _color
	
	

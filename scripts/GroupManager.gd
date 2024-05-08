extends Panel

var all_groups : Array[PriorityTable]
var current_group : PriorityTable
var group_slot = preload("res://interface/Group_slot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	update_group_slots()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#Updates groups slots in grid
func update_group_slots():
	var slots = %GroupGrid.get_children()
	for i in slots:
		i.queue_free()
	#TODO powinien pobierać wszystkie grupy z tabeli grups
	for i in range(6):
		var s = group_slot.instantiate()
		s.set_num(i+1)
		%GroupGrid.add_child(s)
		
#TODO ma znaleźć pierwszą grupę w tabeli i ustawić ją
#resets current group to first in table
func set_first_group():
	pass
	#set_current_group($GroupName.text, group_type : PriorityTable)
		
#Updates group slots
func update_group(groups : Array[PriorityTable]):
	all_groups = groups
	#%GroupList
	
func set_current_group(group_name : String, group_type : PriorityTable):
	#$ColorRect.self_modulate = group_type.color
	$GroupName.text = group_name
	current_group = group_type


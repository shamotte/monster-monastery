extends Panel

@export var group_grid : Node
var all_groups : Array[PriorityTable]
var current_group : PriorityTable
var group_slot = preload("res://interface/Group_slot.tscn")
var priority_slot = preload("res://interface/priority_button.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	update_group_slots()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#Updates groups slots in grid
func update_group_slots():
	var slots = group_grid.get_children()
	for i in slots:
		i.queue_free()
	for i in range(len(Global.current_groups)):
		var s = group_slot.instantiate()
		s.set_group(Global.current_groups[i])
		s.set_num(i+1)
		s.set_color(Global.current_groups[i].color)
		group_grid.add_child(s)
		
#TODO ma znaleźć pierwszą grupę w tabeli i ustawić ją
#resets current group to first in table
func set_first_group():
	var slots = group_grid.get_children()
	if len(slots) > 0:
		current_group = slots[0]._on_button_pressed()	
		
#Updates group slots
func update_group(groups : Array[PriorityTable]):
	all_groups = groups
	#%GroupList
	
func set_current_group(group_type : PriorityTable):
	current_group = group_type
	$GroupName.text = group_type.name
	$GroupColor.color = current_group.color
	var priorities_slot = %PrioritiyList.get_children()
	for i in priorities_slot:
		i.queue_free()
	for i in range(len(current_group.table)):
		var p = priority_slot.instantiate()
		p.change_priority(current_group.table[i])
		p.set_group(current_group,i)
		p.change_icon(i)
		#p.get_node("Icon").texture = Priorities.actions[i]["sprite"]
		%PrioritiyList.add_child(p)
		
	#%GroupGrid

#Return current group
func get_current_group():
	return current_group

extends Button

func add_new_group():
	var group = PriorityTable.new()
	Global.current_groups.append(group)
	return group

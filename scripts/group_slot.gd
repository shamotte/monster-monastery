extends Control

var group : PriorityTable


# Called when the node enters the scene tree for the first time.
func _ready():
	if group != null:
		set_group(group)

#TODO Dokończyć zaznaczanie grupy
#Set Group values
func set_group(newGroup : PriorityTable):
	group = newGroup
	$GroupColor.self_modulate = group.color
	#$Count.text = group.id
	
func set_num(num : int):
	$Count.text = str(num)
	
func set_color(newColor : Color):
	$GroupColor.color = newColor

func get_group():
	return group
	
func _on_button_pressed():
	var manager = get_tree().get_first_node_in_group("GroupInfo")
	manager.set_current_group("Group "+$Count.text,group)

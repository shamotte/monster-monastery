extends Control

var group : PriorityTable
var allow_to_change_group : bool
var allow_to_change_unit_spawn_group : bool


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
	$GroupColor.self_modulate = newColor

func get_group():
	return group

#Show info in manager
func show_group_info():
	var manager = get_tree().get_first_node_in_group("GroupInfo")
	manager.set_current_group(group)

#Allows button to change unit's group
func can_set_unit(option : bool):
	allow_to_change_group = option
	
#Allows button to change spawning group
func can_set_spawn(option : bool):
	allow_to_change_unit_spawn_group = option
	
#Changing unit's group
func change_units_group():
	var info_panel = get_tree().get_first_node_in_group("Info Panel")
	info_panel.change_selected_unit_group(group)
	
func set_spawning_group():
	var unit_info = get_tree().get_first_node_in_group("UnitSpawnInfo")
	unit_info.set_current_group(group)
	
func _on_button_pressed():
	if not allow_to_change_group:
		show_group_info()
	else:
		change_units_group()
	if allow_to_change_unit_spawn_group:
		set_spawning_group()
		

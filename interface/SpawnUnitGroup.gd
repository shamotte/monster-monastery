extends Control

var current_group : PriorityTable
var group_slot = load("res://interface/Group_slot_small.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$GroupSelection.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_group == null and len(Global.current_groups) > 0 :
		set_current_group(Global.current_groups[0])
		
func set_current_group(new_group : PriorityTable):
	current_group = new_group
	$GroupButton/GroupColor.color = current_group.color
	$"GroupButton/Group ID".text = str(current_group.id)
	$GroupSelection.visible = false
	
#When button pressed
func _on_group_button_pressed():
	$GroupSelection.visible = not $GroupSelection.visible
	if $GroupSelection.visible:
		for i in %UnitGroupGrid.get_children():
			i.queue_free()
		for i in range(len(Global.current_groups)):
			var g = group_slot.instantiate()
			g.set_group(Global.current_groups[i])
			g.set_num(i+1)
			g.set_color(Global.current_groups[i].color)
			g.can_set_unit(true)
			g.can_set_spawn(true)
			%UnitGroupGrid.add_child(g)
	
func get_current_group():
	return current_group

	
	
	#var manager = get_tree().get_first_node_in_group("BuildingUI")
	#manager.current_page = manager.pages.GROUPS
	#manager.get_node("Panel").current_tab = manager.current_page
	#manager.get_node("Panel").get_node("GroupManager").get_node("SelectedGroupPanel").set_current_group(current_group.priorities)
	#manager.show_panel(true)
	#manager.selecting_group_mode(true)
	#manager.get_node("CheckButton").button_pressed = true


func _on_add_button_group_pressed():
	current_group = $AddButtonGroup.add_new_group()
	set_current_group(current_group)

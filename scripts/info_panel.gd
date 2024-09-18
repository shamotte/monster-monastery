extends Control

var PRIORITIESLENGTH = 3

var stat_slot = preload("res://interface/stat_slot.tscn") 
var group_slot = preload("res://interface/Group_slot_small.tscn")
var statistics = Global.statistics
var selected_unit : Unit

@onready var priority_box= preload("res://interface/priority_elem.tscn")

@onready var resource_icon = preload("res://interface/resource_slot.tscn")

@onready var building_preview = preload("res://interface/building_previev.tscn")

@export var menu_manager: Node

@onready var pointer:Area2D = %MousePointer
var active_selection

# Called when the node enters the scene tree for the first time.
var camera :Camera2D
func update_priority(index:int,new_value : int):
	if active_selection != null:
		#print("ad")
		if active_selection is Unit:
			active_selection.priorities[index] = new_value
			#print("writing new priority")
		if active_selection is buildingObject:
			#print("clock")
			active_selection.new_value(new_value)
			
			
func _ready():
	camera = get_viewport().get_camera_2d()
	%PreviewGroups.visible = false
	visible = false
	%Cou.value_changed.connect(update_priority)
		
		
	
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index ==1 and event.is_pressed():
			
			var intersections = pointer.get_overlapping_areas()
			
			if not intersections.is_empty():
				active_selection = intersections[0].get_parent()
				active_selection.display_previev($".")
				visible = true

#deselect unit
func deselect():
	active_selection = null
	selected_unit = null
	visible = false
	%SelectedIndicator.visible = false
	%PreviewGroups.visible = false
	
#select unit
func unit_selection(object : Unit):
	$PreviewPanel.visible=true
	if bp != null:
		bp.queue_free();
	selected_unit = object
	
	$PreviewPanel/GroupIdentifier.visible = true
	$PreviewPanel/GroupManagerLink.visible = true
	%PreviewUnitStats.visible = true
	%PreviewGroups.visible = false
	%RecepiePanel.visible = false
	$PreviewPanel/HPTexture.visible = true
	%UnitName.text = object.type.name
	%HP.visible = true
	%HP.text = str(object.hp) + "/" + str(object.type.hp)
	
	%preview_icon.texture = object.type.sprite
	active_selection = object
	#TODO tu byłe error
	#for p in range(len(object.priorities)):
		#%PriorityBoxes.get_child(p).change_priority(object.priorities[p])
		#pass
	#remove older stats
	for i in %InfoPanelStats.get_children():
		i.queue_free()
	#Display unit statistics
	for i in statistics:
		if statistics[i] == statistics.HP:
			continue
		var s = stat_slot.instantiate()
		match statistics[i]:
			statistics.ATTACK:
				s.set_attack(object.type.damage)
			statistics.SPEED:
				s.set_speed(object.type.speed)
			statistics.ATTACKRANGE:
				s.set_attackRange(object.type.fight_range)
			statistics.COOLDOWN:
				s.set_attackCooldown(object.type.cooldown)
			statistics.WORKRANGE:
				s.set_workRange(object.type.work_range)
			statistics.WORKTIME:
				s.set_workTime(object.type.work_speed)
		%InfoPanelStats.add_child(s)
	
	

var bp:BuildingPreview = null
#select building
func building_selection(object : buildingObject):
	if bp != null:
		bp.queue_free();
	selected_unit = null
	$PreviewPanel.visible=false
	$PreviewPanel/GroupIdentifier.visible = false
	$PreviewPanel/GroupManagerLink.visible = false
	%PreviewUnitStats.visible = false
	%PreviewGroups.visible = false
	%HP.visible = false
	$PreviewPanel/HPTexture.visible = false
	bp = building_preview.instantiate();
	
	bp.object = object
	add_child(bp)
	
	

func _process(delta):
	#Check if Menu Manager is active so player can't select unit while in menu
	if $"../Manager/Panel".visible:
		return
	if selected_unit != null:
		$PreviewPanel/GroupIdentifier.text = "Group: " + str(selected_unit.priorities.id)
		$PreviewPanel/GroupIdentifier.set("theme_override_colors/font_color", selected_unit.priorities.color)
	
	pointer.global_position = $"../../..".mousePos()
	
	if active_selection != null:
		%SelectedIndicator.global_position = active_selection.global_position
		%SelectedIndicator.visible = true
		if selected_unit != null:
			%HP.text = str(selected_unit.hp) + "/" + str(selected_unit.type.hp)
	else:
		%SelectedIndicator.visible = false
		
		
	if Input.is_action_just_pressed("back"):
		hide_panel(true)

#Priority button pressed
func _on_group_manager_link_pressed():
	menu_manager.current_page = menu_manager.pages.GROUPS
	menu_manager.get_node("Panel").current_tab = menu_manager.current_page
	menu_manager.get_node("Panel").get_node("GroupManager").get_node("SelectedGroupPanel").set_current_group(selected_unit.priorities)
	menu_manager.show_panel(true)
	menu_manager.get_node("CheckButton").button_pressed = true
	deselect()
	
#group selection button pressed
func _on_group_identifier_pressed():
	#change state of group panel
	%PreviewGroups.visible = not %PreviewGroups.visible
	if %PreviewGroups.visible:
		#Removing old groups
		for i in %InfoPanelGroups.get_children():
			i.queue_free()
		#Spawn updated groups
		for i in range(len(Global.current_groups)):
			var g = group_slot.instantiate()
			g.set_group(Global.current_groups[i])
			g.set_num(i+1)
			g.set_color(Global.current_groups[i].color)
			g.can_set_unit(true)
			%InfoPanelGroups.add_child(g)
			
#changes group of selected unit
func change_selected_unit_group(new_group : PriorityTable):
	%PreviewGroups.visible = false
	if selected_unit == null:
		return
	selected_unit.set_group(new_group)

#hides panel	
func hide_panel(hide):
	%PreviewPanel.visible = !hide
	%PreviewUnitStats.visible = !hide
	%PreviewGroups.visible = !hide	
	deselect()
	
	
var mouse_in:bool
func _on_mouse_entered():
	mouse_in = true # Replace with function body.


func _on_mouse_exited():
	mouse_in = false # Replace with function body.


func _on_preview_panel_mouse_entered():
	_on_mouse_entered() # Replace with function body.


func _on_preview_panel_mouse_exited():
	_on_mouse_exited()


func _on_control_mouse_entered():
	_on_mouse_entered() # Replace with function body.


func _on_control_mouse_exited():
	_on_mouse_exited()

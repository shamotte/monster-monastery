extends Control

var PRIORITIESLENGTH = 3
@onready var priority_box= preload("res://object/priority_elem.tscn")
# Called when the node enters the scene tree for the first time.
var camera :Camera2D
func update_priority(index:int,new_value : int):
	if active_selection != null:
		#print("ad")
		if active_selection is unit:
			active_selection.priorities[index] = new_value
			#print("writing new priority")
		if active_selection is buildingObject:
			#print("clock")
			active_selection.new_walue(new_value)
			
			
func _ready():
	camera = get_viewport().get_camera_2d()
	%PriorityBoxes.visible= false
	%PreviewPanel.visible = false
	%Cou.value_changed.connect(update_priority)
	for p in range(PRIORITIESLENGTH):
		var child = priority_box.instantiate() 
		child.priority = 0
		child.index = p
		child.value_changed.connect(update_priority)
		%PriorityBoxes.add_child(child)
		child.change_label(p)
		child.change_icon(p)
		child.mouse_entered.connect(_on_mouse_entered)
		
		
	
	

@onready var pointer:Area2D = %MousePointer
var active_selection
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index ==1 and event.is_pressed():
			
			var intersections = pointer.get_overlapping_areas()
			
			if not intersections.is_empty():
				active_selection = intersections[0].get_parent()
				active_selection.display_previev($".")
				%PreviewPanel.visible = true



func unit_selection(object : unit):
	$PreviewPanel/HPTexture.visible = true
	%UnitName.text = Global.units[object.type].name
	%HP.visible = true
	%HP.text = str(object.hp)
	
	%preview_icon.texture = object.get_node("Sprite").texture
	%PriorityBoxes.visible = true
	%RecepiePanel.visible = false
	active_selection = object
	
	for p in range(len(object.priorities)):
		%PriorityBoxes.get_child(p).change_priority(object.priorities[p])
		
	
func resource_selection(object : Res):
	%PriorityBoxes.visible = false
	%RecepiePanel.visible = false
	%HP.visible = false
	$PreviewPanel/HPTexture.visible = false
	%UnitName.text = Global.resources[object.resource_type].name
	%preview_icon.texture = object.get_node("Sprite2D").texture
	
	
@onready var resource_icon = preload("res://interface/resource_slot.tscn")
func building_selection(object : buildingObject):
	%PriorityBoxes.visible = false
	%RecepiePanel.visible = true
	%HP.visible = false
	$PreviewPanel/HPTexture.visible = false
	%preview_icon.texture = object.get_node("Sprite2D").texture
	%UnitName.text = Global.buildings[object.building_type].name
	%Cou.change_priority(object.to_craft)
	var recipe = object.recipe
	for chil in %ingred.get_children():
		chil.queue_free()
	for chil in %benefit.get_children():
		chil.queue_free()
	for igr in Global.recipes[recipe].ingredients:
		var x = resource_icon.instantiate()
		x.get_node("Sprite").texture= Global.resources[igr[0]].sprite
		x.get_node("Count").text = str(igr[1])
		%ingred.add_child(x)
	for res in Global.recipes[recipe].results:
		var x = resource_icon.instantiate()
		x.get_node("Sprite").texture= Global.resources[res[0]].sprite
		x.get_node("Count").text = str(res[1])
		%benefit.add_child(x)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pointer.global_position = $"../../..".mousePos()
	
	if active_selection != null:
		%SelectedIndicator.global_position = active_selection.global_position
		%SelectedIndicator.visible = true
	else:
		%SelectedIndicator.visible = false


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

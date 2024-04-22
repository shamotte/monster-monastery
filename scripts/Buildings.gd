extends Node

var selected_building = -1
@export var building:BuildingResource
@export var buildingObject = preload("res://object/tower.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("left_mouse_button"):
		build_building(mousePosition())
	if Input.is_action_just_pressed("back") or Input.is_action_just_pressed("right_mouse_button"):
		UnselectObject()
	if selected_building != -1:
		$"../../CursorSprite".position = mousePosition()
		$"../../CursorSprite".texture = building.sprite
	else:
		$"../../CursorSprite".global_position = mousePosition()

func build_building(position):
	if selected_building != -1:
		#Is building overlap other object
		var Cursor = get_tree().get_first_node_in_group("CursorOverlaping")
		if Cursor.is_overalaping():
			return
		#paying for building 
		if !Global.check_and_subtract_resources(building.resource_cost):
			return
		#Summoning Object
		var newBuilding = buildingObject.instantiate()
		newBuilding.position = position
		newBuilding.set_stats(building)
		add_child(newBuilding)
		UnselectObject()
	
#set id for building
func set_building_id(id):
	selected_building = id
	building = Global.buildings[selected_building]
	
func mousePosition():
	return $"../..".mousePos()
	
func UnselectObject():
	selected_building = -1
	building = null
	$"../../CursorSprite".texture = null
	 

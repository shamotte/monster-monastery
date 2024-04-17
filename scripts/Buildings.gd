extends Node

var selected_building = -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("left_mouse_button"):
		build_building(mousePosition())
	if Input.is_action_just_pressed("back") or Input.is_action_just_pressed("right_mouse_button"):
		UnselectObject()
	if selected_building != -1:
		$"../../CursorSprite".position = mousePosition()
		$"../../CursorSprite".texture = Global.buildings[selected_building]["sprite"]
	else:
		$"../../CursorSprite".global_position = mousePosition()

func build_building(position):
	if selected_building != -1:
		#Is building overlap other object
		var Cursor = get_tree().get_first_node_in_group("CursorOverlaping")
		if Cursor.is_overalaping():
			return
		#paying for building
		for i in range(Global.buildings[selected_building]["resource_type"].size()):
			Global.current_resources[Global.buildings[selected_building]["resource_type"][i]] -= Global.buildings[selected_building]["resource_cost"][i]
		#Summoning Object
		var newBuilding = Global.buildings[selected_building]["object"].instantiate()
		#newBuilding.set_texture(Global.buildings[selected_building]["sprite"])
		newBuilding.set_stats(selected_building)
		#newBuilding.set_id(Global.buildings[selected_building]["sprite"])
		newBuilding.building_type = selected_building
		newBuilding.position = position
		add_child(newBuilding)
		UnselectObject()
	
#set id for building
func set_building_id(id):
	selected_building = id
	
func mousePosition():
	return $"../..".mousePos()
	
func UnselectObject():
	selected_building = -1
	$"../../CursorSprite".texture = null
	 

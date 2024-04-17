extends Node

var selected_unit = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("left_mouse_button"):
		build_unit(mousePosition())
	if Input.is_action_just_pressed("back") or Input.is_action_just_pressed("right_mouse_button"):
		UnselectObject()
	if selected_unit != -1:
		$"../../CursorSprite".position = mousePosition()
		$"../../CursorSprite".texture = Global.units[selected_unit]["sprite"]
	else:
		$"../../CursorSprite".global_position = mousePosition()
		

func build_unit(position):
	if selected_unit != -1:
		#Checking if cursor is in right place
		var Cursor = get_tree().get_first_node_in_group("CursorOverlaping")
		if Cursor.is_overalaping():
			return
		#paying for building
		for i in range(Global.units[selected_unit]["resource_type"].size()):
			Global.current_resources[Global.units[selected_unit]["resource_type"][i]] -= Global.units[selected_unit]["resource_cost"][i]
		#Summoning Object
		var newUnit = Global.units[selected_unit]["object"].instantiate()
		newUnit.setStats(selected_unit) 
		newUnit.position = position
		add_child(newUnit)
		UnselectObject()

#set id for unit
func set_unit_id(id):
	selected_unit = id
	
func mousePosition():
	return $"../..".mousePos()
	
func UnselectObject():
	selected_unit = -1
	$"../../CursorSprite".texture = null

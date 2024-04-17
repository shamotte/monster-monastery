extends Control

var building: Global.BUILDINGS
var c

# Called when the node enters the scene tree for the first time.
func _ready():
	c = $Cost.get_children()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in range(Global.buildings[building]["resource_type"].size()):
		if Global.current_resources[ Global.buildings[building]["resource_type"][i] ] < Global.buildings[building]["resource_cost"][i]:
			c[i].get_node("Count").modulate = "#cc425e"
		else:
			c[i].get_node("Count").modulate = "#ffffff"
	
	#for i in range(Global.buildings[building]["resource_type"].size()):
	#	if Global.current_resources[ Global.buildings[building]["resource_type"][i] ] < Global.buildings[building]["resource_cost"][i]:
	#		return


func _on_button_pressed():
	#checking if player can buy building
	for i in range(Global.buildings[building]["resource_type"].size()):
		if Global.current_resources[ Global.buildings[building]["resource_type"][i] ] < Global.buildings[building]["resource_cost"][i]:
			return
	
	#Set Building ID
	var manager = get_tree().get_first_node_in_group("BuildingManager")
	manager.set_building_id(building)
	#Hide Building Panel
	var managerUI = get_tree().get_first_node_in_group("BuildingUI")
	managerUI.hide_panel(true)

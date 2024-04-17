extends Control

var building: BuildingResource
var c

# Called when the node enters the scene tree for the first time.
func _ready():
	c = $Cost.get_children()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in building.resource_cost:
		if Global.current_resources[i.type] < i.count:
			c[i].get_node("Count").modulate = "#cc425e"
		else:
			c[i].get_node("Count").modulate = "#ffffff"
	
	#for i in range(Global.buildings[building]["resource_type"].size()):
	#	if Global.current_resources[ Global.buildings[building]["resource_type"][i] ] < Global.buildings[building]["resource_cost"][i]:
	#		return


func _on_button_pressed():
	for i in building.resource_cost:
		if Global.current_resources[i.type] < i.count:
			return
	
	#Set Building ID
	var manager = get_tree().get_first_node_in_group("BuildingManager")
	manager.set_building_id(0)
	#Hide Building Panel
	var managerUI = get_tree().get_first_node_in_group("BuildingUI")
	managerUI.hide_panel(true)

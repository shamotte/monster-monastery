extends Control

var building_id
var building: BuildingResource
var c

# Called when the node enters the scene tree for the first time.
func _ready():
	c = $Cost.get_children()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var slotnum = 0
	for i in building.resource_cost:
		if Global.current_resources[i.type] < i.count:
			c[slotnum].get_node("Count").modulate = "#cc425e"
		else:
			c[slotnum].get_node("Count").modulate = "#ffffff"
		slotnum += 1
	
	#for i in range(Global.buildings[building]["resource_type"].size()):
	#	if Global.current_resources[ Global.buildings[building]["resource_type"][i] ] < Global.buildings[building]["resource_cost"][i]:
	#		return


func _on_button_pressed():
	print("pressed")
	for i in building.resource_cost:
		if Global.current_resources[i.type] < i.count:
			return
	
	#Set Building ID
	var manager = get_tree().get_first_node_in_group("BuildingManager")
	manager.set_building_id(building_id)
	#Hide Building Panel
	var managerUI = get_tree().get_first_node_in_group("BuildingUI")
	managerUI.hide_panel(true)
	
func set_building_id(id: int):
	building_id = id
	

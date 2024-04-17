extends Control

var units: Global.UNIT
var c

# Called when the node enters the scene tree for the first time.
func _ready():
	c = $Cost.get_children()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in range(Global.units[units]["resource_type"].size()):
		if Global.current_resources[ Global.units[units]["resource_type"][i] ] < Global.units[units]["resource_cost"][i]:
			c[i].get_node("Count").modulate = "#cc425e"
		else:
			c[i].get_node("Count").modulate = "#ffffff"
			
func _on_button_pressed():
	
	#checking if player can buy unit
	for i in range(Global.units[units]["resource_type"].size()):
		if Global.current_resources[ Global.units[units]["resource_type"][i] ] < Global.units[units]["resource_cost"][i]:
			return
	var manager = get_tree().get_first_node_in_group("Units")
	manager.set_unit_id(units)
	var managerUI = get_tree().get_first_node_in_group("BuildingUI")
	managerUI.hide_panel(true)

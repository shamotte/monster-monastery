extends Control

var building_cost = preload("res://interface/item_slot.tscn")
var recipes = preload("res://interface/RecipeInfo.tscn")

var building_id
var building: BuildingResource
var c
var building_info

# Called when the node enters the scene tree for the first time.
func _ready():
	c = $Cost.get_children()
	building_info = get_tree().get_first_node_in_group("BuildingSpawnInfo")
	set_info_panel()

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
	
func _on_button_mouse_entered():
	set_info_panel()
	#%BuildingInfo/Name.text = str(building.name)
	
func set_building_id(id: int):
	building_id = id
	
#Set values for info panel
func set_info_panel():
	#setting data
	building_info.get_node("Name").text = building.name
	building_info.get_node("Image").texture = building.sprite
	#remove older cost
	for i in building_info.get_node("Cost").get_children():
		i.queue_free()
	#adding new cost
	for i in building.resource_cost:
		var c = building_cost.instantiate()
		c.stack = i
		building_info.get_node("Cost").add_child(c)
	#remove older craftings	
	for i in building_info.get_node("Crafting").get_children():
		i.queue_free()
	#add current building crafting recipes
	for i in building.recipes:
		var r = recipes.instantiate()
		for j in i.input:
			var s = building_cost.instantiate()
			s.stack = j
			r.get_node("Igredients").add_child(s)
		for j in i.output:
			var s = building_cost.instantiate()
			s.stack = j
			r.get_node("Result").add_child(s)
		building_info.get_node("Crafting").add_child(r)
	

	
	



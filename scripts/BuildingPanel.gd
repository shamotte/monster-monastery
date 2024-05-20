extends Control

var current_building = BuildingResource



@onready var resource_icon = preload("res://interface/resource_slot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#select building
func building_selection(object : buildingObject):
	#current_building = 
	hide_panel(false)
	%InfoPanel.hide_panel(true)
	$Panel/PreviewSprite.texture = object.building.sprite
	$Panel/BuildingName.text = object.building.name
	%Cou.change_priority(object.to_craft)
	var recipe = object.recipe
	for chil in %ingred.get_children():
		chil.queue_free()
	for chil in %benefit.get_children():
		chil.queue_free()
	#TODO żeby dało się więcej craftingów
	#Required ingriedients
	for igr in object.building.recipes[0].input: 
		var x = resource_icon.instantiate()
		x.get_node("Sprite").texture = Global.resources[igr.type].sprite
		x.get_node("Count").text = str(igr.count)
		%ingred.add_child(x)
	#result 
	for res in object.building.recipes[0].output: 
		var x = resource_icon.instantiate()
		x.get_node("Sprite").texture= Global.resources[res.type].sprite
		x.get_node("Count").text = str(res.count)
		%benefit.add_child(x)
		
func hide_panel(hide):
	$Panel.visible = !hide

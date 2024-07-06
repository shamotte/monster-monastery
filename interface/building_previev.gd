extends Control
class_name BuildingPreview
var texture : Sprite2D
var building_name : String
var object : buildingObject
@onready var resource_icon = preload("res://interface/resource_slot.tscn")

func _process(delta):
	%Cou.caounter = object.to_craft

func _ready():
	#%preview_icon.texture = object.building.sprite
	%BuildingName.text = object.building.name
	%Cou.new_value.connect(new_recepie)
	
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
		pass
		
func new_recepie(new_to_craft : int):
	object.new_value(new_to_craft)
	


func _on_priority_elem_pressed():
	pass # Replace with function body.

extends Node2D
class_name buildingObject
var texture = null
@onready var id = Priorities.get_id()

@export var building : BuildingResource

var recipe :RecipeResource
var to_craft = 0
var busy = false
var units_working_on_this : int = 0

var work_time:float

func _process(delta):
	if not busy:
		if to_craft >0 and Global.check_and_subtract_resources(recipe.input):
			Priorities.add_self_to_available_actions(self, Priorities.ACTIONTYPES.CRAFT)
			busy = true
			

func work_on(delta:float):
	if to_craft == 0:
		return true
	if work_time <=0 :
		return true
	work_time -=delta
	if work_time <= 0:
		Priorities.remove_self_from_actions(self, Priorities.ACTIONTYPES.CRAFT);
		action_finished()
		return true

func action_finished():
	await get_tree().process_frame
	to_craft-=1
	if to_craft > 0 and Global.check_and_subtract_resources(recipe.input):
		Priorities.add_self_to_available_actions(self, Priorities.ACTIONTYPES.CRAFT)
	else:
		busy = false
	work_time = recipe.craft_time
	$CompleteSound.play()
	
	Global.add_resources(recipe.output)
		
func _ready():
	$AnimationPlayer.play("spawn")
	$SpawnSound.play()
	recipe =  building.recipes[0]
	work_time =  recipe.craft_time
	#Priorities.add_action(Priorities.ACTIONTYPES.CRAFT,id,get_node("."),Global.recipes[recipe].work)# Replace with function body.


		
func display_previev(node):
	node.building_selection(get_node("."))
	
func new_value(value):
	to_craft = value
	if to_craft>0 and busy == false:
		busy =true
		Priorities.add_self_to_available_actions(self, Priorities.ACTIONTYPES.CRAFT)

#Set data of building
func set_stats(newBuilding: BuildingResource):
	building = newBuilding
	recipe = building.recipes[0]
	$Sprite2D.texture = building.sprite
	$Shadow.texture = building.sprite
	$AnimatedSprite2D.animation = "default"

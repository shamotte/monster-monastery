extends Node2D
class_name buildingObject
var texture = null
@onready var id = Priorities.get_id()

@export var building : BuildingResource

var recipe 
var to_craft = 0
var busy = false



func action_finished():
	busy = false
	$CompleteSound.play()
	for elem in Global.recipes[recipe].results:
		Global.add_resources(recipe.output)
		
func _ready():
	$AnimationPlayer.play("spawn")
	$SpawnSound.play()
	recipe =  building.recipes[0]
	#Priorities.add_action(Priorities.ACTIONTYPES.CRAFT,id,get_node("."),Global.recipes[recipe].work)# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not busy:
		if to_craft>0:
			#for i in range(Global.buildings[building]["resource_type"].size()):
			#	if Global.current_resources[ Global.buildings[building]["resource_type"][i] ] < Global.buildings[building]["resource_cost"][i]:
			for i in recipe.input:	
				if i.count > Global.get_resource_count(i.type):
					return
			
			Global.subtract_resources(recipe.input)
			
			Priorities.add_action(Priorities.ACTIONTYPES.CRAFT,id,$".",Global.recipes[recipe].work)
			to_craft-=1
			busy = true
		
		
func display_previev(node):
	node.building_selection(get_node("."))
	
func new_walue(value):
	to_craft = value
	
func set_texture(newTexture):
	texture = newTexture
	$Sprite2D.texture = newTexture
	$AnimatedSprite2D.animation = "default"
	
func set_stats(id: BuildingResource):
	building = id 
	recipe = building.recipes[0]
	$Sprite2D.texture = building.sprite
	$AnimatedSprite2D.animation = "default"

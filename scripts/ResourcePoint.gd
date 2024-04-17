extends Node2D
class_name Res

@export var resource_type: Global.RESOURCE
@export var resource_count_initial: int = 3
var resource_count = resource_count_initial

@onready var id =  Priorities.get_id()

func action_finished():
	if resource_count <= 0:
		return
		
	resource_count-=1;
	Global.add_resources(resource_type, 1)
	
	if resource_count < resource_count_initial:
		$Health.visible = true
		$Health.max_value = resource_count_initial
		$Health.value = resource_count
	
	if resource_count != 0:
		await get_tree().create_timer(10.0).timeout
		add_self_to_available_actions()
	else:
		visible = false
		$RespawnTimer.start()
		$Health.visible = false

	

func add_self_to_available_actions():
	
	Priorities.add_action(Global.resources[resource_type].type,id,get_node("."),Global.resources[resource_type].time)
	
func _ready():
	$Sprite2D.texture = Global.resources[resource_type]["resource_point_texture"]
	add_self_to_available_actions()
	
	$AnimationPlayer.play("spawn")
	
	
func display_previev(node : Control):
		node.resource_selection(self)



func _on_respawn_timer_timeout():
	visible = true
	resource_count = resource_count_initial
	add_self_to_available_actions()
	$AnimationPlayer.play("spawn")

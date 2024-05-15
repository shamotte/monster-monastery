extends Node2D
class_name Res

@export var resource_count_initial: int = 1
var resource_count = resource_count_initial
@export var res: ResourceResource = preload("res://resources/resources/wood.tres")
@onready var id = Priorities.get_id()
var work_time :float
var units_working_on_this = 0

func action_finished():
	Priorities.remove_self_from_actions(self, Priorities.ACTIONTYPES.GATHER)
	if resource_count <= 0:
		return
		
	resource_count-=1;
	Global.add_resources([ResourceStack.new(res.type,1)])
	
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
	Priorities.add_self_to_available_actions(self,Priorities.ACTIONTYPES.GATHER)
	finished = false
	work_time = res.time
	
var finished : bool = false
func work_on(work : float) -> bool: # return true if the task is finished 
	if finished:
		return true
	work_time -=work
	if work_time <0:
		finished = true
		action_finished()
		return true
	return false
	
	
func _ready():
	randomize_resource()
	
	add_self_to_available_actions()
	
	$AnimationPlayer.play("spawn")



func _on_respawn_timer_timeout():
	visible = true
	resource_count = resource_count_initial
	randomize_resource()
	add_self_to_available_actions()
	$AnimationPlayer.play("spawn")
	



var rock_replacements = [
	preload("res://resources/resources/rock.tres"),
	preload("res://resources/resources/obsydian.tres"),
	preload("res://resources/resources/gold.tres"),
	preload("res://resources/resources/iron.tres"),
	preload("res://resources/resources/gem.tres"),
]
func randomize_resource():
	if res in rock_replacements:
		res = rock_replacements.pick_random()
			
	$Sprite2D.texture = res.resource_point_txture
	$Shadow.texture = res.resource_point_txture
	work_time = res.time

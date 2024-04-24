extends CharacterBody2D
class_name Unit

@export var type: UnitResource


@onready var agent : NavigationAgent2D = %NavAgent
var priorities = [1,1,1]#tablica wskazująca priorytety danych akcji w takiej samej kolejności jak w enumie Priorities.ACTIONTYPES

var work_time: float


var summoning_time :float = 3.0
var current_action:Priorities.action
		
@onready var state_machine: StateMachine.UnitStateMachine = StateMachine.UnitStateMachine.new()

var hp
func _ready():
	state_machine.set_up(self)
	$SpawnSound.play()
	$AnimationPlayer.play("spawn")
	hp = type.hp
	#state_machine.states[StateMachine.STATES.FIGHT].connect("fight_process",debug_test);



func _process(delta):
	state_machine.process(delta)
	#Is animation end
	#Rotation
	if velocity.x > 0:
		$Sprite.flip_h = false
		$Sprite/ItemParent.scale.x = 1.0
	elif velocity.x < 0:
		$Sprite.flip_h = true
		$Sprite/ItemParent.scale.x = -1.0
	

func setStats(unitId):
	$Sprite.texture = type.sprite
	#$Sprite/ItemParent/Item.texture = Global.units[unitId]["toolSprite"]


func _physics_process(delta):
	state_machine.physics_process(delta)
	


func display_previev(node : Control):
		node.unit_selection(self)
	

	
func take_damage(damage:float):
	hp -= damage
	if hp<=0:
		queue_free()
	
func debug_test():
	print("fghting")


func _on_tree_entered():
	Global.unit_count += 1


func _on_tree_exiting():
	Global.unit_count -= 1

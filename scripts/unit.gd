extends CharacterBody2D
class_name Unit

@export var type: UnitResource

@onready var agent : NavigationAgent2D = %NavAgent

var priorities : PriorityTable


var work_time: float

var abilities:Array[Ability]
var summoning_time :float = 3.0
		
@onready var state_machine: StateMachine.UnitStateMachine = StateMachine.UnitStateMachine.new()


var current_action:Node2D = null
var target:Enemy = null
var target_global_position: Vector2

signal process_sig( delta : float)

var hp
func _ready():
	set_current_group()
	#priorities = PriorityTable.new()
	$SpawnSound.play()
	$AnimationPlayer.play("spawn")
	
	hp = type.hp
	$Sprite.texture = type.sprite
	$Shadow.texture = type.sprite
	$Sprite/ItemParent/Item.texture = type.item
	for ab :Ability in type.abilities:
		var temp = ab.duplicate()
		if temp.has_method("process"):
			process_sig.connect(temp.process)
		if temp.has_method("init"):
			temp.init()
		temp.ovner = self
		abilities.push_back(temp)
		
	state_machine.set_up(self)
	#HP Bar
	%HPBar.max_value = type.hp
	%HPBar.visible = false
	#state_machine.states[StateMachine.STATES.FIGHT].connect("fight_process",debug_test);
	


func _process(delta):
	
	
	state_machine.process(delta)
	
	process_sig.emit(delta)
	#Is animation end
	#Rotation
	if velocity.x > 0:
		$Sprite.flip_h = false
		$Shadow.flip_h = false
		$Sprite/ItemParent.scale.x = 1.0
	elif velocity.x < 0:
		$Sprite.flip_h = true
		$Shadow.flip_h = true
		$Sprite/ItemParent.scale.x = -1.0

func _physics_process(delta):
	state_machine.physics_process(delta)
	


func display_previev(node : Control):
		node.unit_selection(self)
	

	
func take_damage(damage:float):
	hp -= damage
	%HPBar.visible = true
	%HPBar.value = hp
	if hp<=0:
		queue_free()
		
func heal_unit(addHP:float):
	hp += addHP
	%HPBar.value = hp
	if hp >= type.hp:
		%HPBar.visible = false
		hp = type.hp
		
#Makes and set new group
func make_and_set_new_group():
	priorities = PriorityTable.new()
	priorities.units_in_group += 1
	Global.current_groups.append(priorities)
	
#set current selected group
func set_current_group():
	if len(Global.current_groups) == 0:
		make_and_set_new_group()
	else:
		var unit_info = get_tree().get_first_node_in_group("UnitSpawnInfo")
		priorities = unit_info.get_current_group()
		priorities.units_in_group += 1
	#unit_info.set_current_group(group)
	#priorities
	

	
func set_group(group : PriorityTable):
	priorities.units_in_group -= 1
	priorities = group
	priorities.units_in_group += 1
	
func _draw():
	pass#draw_arc(position,700,0,360,50,Color.RED,0.2)

func _on_tree_entered():
	Global.unit_count += 1


func _on_tree_exiting():
	Global.unit_count -= 1

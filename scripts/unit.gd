extends CharacterBody2D
class_name Unit

@export var type: UnitResource

@onready var agent : NavigationAgent2D = %NavAgent

var priorities : PriorityTable


var work_time: float

var abilities:Array[Ability]
var summoning_time :float = 3.0
		
@onready var state_machine: StateMachine.UnitStateMachine = StateMachine.UnitStateMachine.new()

var last_position : Vector2

var current_action:Node2D = null
var target:Enemy = null
var target_global_position: Vector2

signal process_sig( delta : float)
signal unit_died

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
	$Sprite.self_modulate = type.color 
	$Sprite/ItemParent/Item.self_modulate = type.color
	scale = Vector2(type.scale,type.scale)
	for ab :Ability in type.abilities:
		var temp = ab.duplicate()
		if temp.has_method("process"):
			process_sig.connect(temp.process)
		if temp.has_method("init"):
			temp.init(self)
		if temp.has_method("on_death"):
			unit_died.connect(temp.on_death)
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
	
	#Animation 
	#print(position)
	if $AnimationPlayer.current_animation != "spawn" and $AnimationPlayer.current_animation != "Dead": 
		if position != last_position:
			next_anim("walk")
			last_position = position
		else:
			next_anim("Idle")
	


func display_previev(node : Control):
		node.unit_selection(self)
	

	
func take_damage(damage:float) -> int:
	hp -= damage
	%HPBar.visible = true
	%HPBar.value = hp
	if hp<=0:
		hp = 0
		unit_died.emit()
		if type.play_dead_anim:
			$AnimationPlayer.play("Dead")
			return damage + hp
		kill()
		return damage + hp
	$SelfRegeneration.stop()
	$FightTimer.start()
	return damage
		
func heal_unit(addHP:float):
	hp += addHP
	%HPBar.value = hp
	if hp >= type.hp:
		%HPBar.visible = false
		$SelfRegeneration.stop()
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
	
func set_action_icon(Icon):
	$ActionIcon.texture = Icon 
	
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
	
func kill():
	queue_free()
	
func next_anim(anim_name : String):
	$AnimationPlayer.play(anim_name)
	
#self regeneration at night
func _on_self_regeneration_timeout() -> void:
	if DaylightManager.is_night():
		if hp < type.hp:
			heal_unit(1)
	

#end lack of regeneration after taking damage
func _on_fight_timer_timeout() -> void:
	$SelfRegeneration.start()
	$FightTimer.stop()

class_name Enemy
extends CharacterBody2D
@export var type:EnemyResource

@onready var hp:float

signal died
@onready var id = Priorities.get_id()
@onready var units = get_node("/root/Game/GameSpace/Units")
var target = null
@onready var agent: NavigationAgent2D = %agent

var units_working_on_this:int = 0
var cooldown:float = 0
var ability :Ability
var range : float

signal fight_process(delta: float)

func _ready():
	Priorities.add_self_to_available_actions(self,Priorities.ACTIONTYPES.FIGHT)
	if type.ability != null:
		ability = type.ability.duplicate(true)
		ability.ovner = self
		ability.to_target = 128
		range = ability.range
		if ability.has_method("fight_process"):
				connect("fight_process",ability.fight_process)
		if ability.has_method("init"):
			ability.init(self)
	
	%HPBar.visible = false
	$AnimationPlayer.play("spawn")

func set_stats(newEnemy:EnemyResource):
	type = newEnemy
	hp = type.hp
	if type.cooldown <= 0 :
		pass
	$Sprite2D.texture = type.sprite
	$Shadow.texture = type.sprite
	%Item.texture = type.item
	%HPBar.value = type.hp
	%HPBar.max_value = type.hp
	
func modify_hp(modifier : float):
	hp = floor(type.hp * modifier)
	%HPBar.value = hp
	%HPBar.max_value = hp

func take_damage(damage:float) -> int:
	hp-=damage
	if hp<=type.hp:
		%HPBar.visible = true
		%HPBar.value = hp
	if hp<=0:
		died.emit()
		Priorities.remove_self_from_actions(self,Priorities.ACTIONTYPES.FIGHT)
		$AnimationPlayer.play("Dead")
		return damage + hp
	return damage

func get_closest_unit()-> Node2D:
	var distance = 0
	var min_distance = 200000000
	var node = null
	for unit in units.get_children():
		distance = position.direction_to(unit.position)
		if distance.length() < min_distance:
			min_distance = distance.length()
			node = unit
	return node
		
var target_global_position : Vector2

func _process(delta):
	if target != null:
		agent.target_position = target.position
		target_global_position = target.global_position
		fight_process.emit(delta)
	else:
		target = get_closest_unit()
		



	
func _physics_process(delta):

	if target!=null:
		if global_position.distance_to(target.position) >= range * 0.7:
			var direction = agent.get_next_path_position() - global_position
			direction = direction.normalized()
			velocity = velocity.lerp(direction * type.speed , 0.25)
			move_and_slide()
	
	
	if $AnimationPlayer.current_animation != "spawn" and $AnimationPlayer.current_animation != "Dead": 
		if $AnimationPlayer.current_animation != "walk":
			$AnimationPlayer.play("walk")
			
	if velocity.x > 0:
		$Sprite2D.flip_h = false
		$Shadow.flip_h = false
		$Sprite2D/ItemParent.scale.x = 1.0
	elif velocity.x < 0:
		$Sprite2D.flip_h = true
		$Shadow.flip_h = true
		$Sprite2D/ItemParent.scale.x = -1.0


func heal_unit(addHP:float):
	hp += addHP
	%HPBar.value = hp
	if hp >= type.hp:
		%HPBar.visible = false
		hp = type.hp
		
func kill():
	Global.enemy_killed(type)
	queue_free()

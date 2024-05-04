class_name Enemy
extends CharacterBody2D
@export var type:EnemyResource

@onready var hp:float

signal died
@onready var id = Priorities.get_id()
@onready var units = get_node("/root/Game/GameSpace/Units")
var target = null
@onready var agent: NavigationAgent2D = %agent
@onready var timer : Timer = %Timer

var units_working_on_this:int = 0

func _ready():
	Priorities.add_self_to_available_actions(self,Priorities.ACTIONTYPES.FIGHT)
	%Timer.wait_time = type.cooldown
	$SpawnSound.play()
	
	$AnimationPlayer.play("spawn")

func set_stats(newEnemy:EnemyResource):
	type = newEnemy
	hp = type.hp
	$Sprite2D.texture = type.sprite
	%Item.texture = type.item

func take_damage(damage:float):
	hp-=damage
	if hp<=0:
		died.emit()
		Priorities.remove_self_from_actions(self,Priorities.ACTIONTYPES.FIGHT)
		await get_tree().create_timer(0.1).timeout
		queue_free()

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
		
func _process(delta):
	if target != null:
		agent.target_position = target.position
		if agent.distance_to_target() <= type.fight_range:
			attack(target)
	else:
		target = get_closest_unit()
		
func attack(target: Node2D):
	if type.cooldown:
		type.cooldown = false
		timer.start(type.cooldown)
		if target!= null:
			%attac_area.global_position = target.position
			#print("atacking")
			$AttackSound.play()
			for unit in %attac_area.get_overlapping_bodies():
				unit.take_damage(type.damage)


func _on_timer_timeout():
	type.cooldown = true
	
func _physics_process(delta):
	#check is type set
	if type == null:
		return
	if target!=null:
		if global_position.distance_to(target.position) >= type.fight_range:
			var direction = agent.get_next_path_position() - global_position
			direction = direction.normalized()
			velocity = velocity.lerp(direction * type.speed , 0.25)
			move_and_slide()
	
	
	if $AnimationPlayer.current_animation != "spawn":
		if $AnimationPlayer.current_animation != "walk":
			$AnimationPlayer.play("walk")
			
	if velocity.x > 0:
		$Sprite2D.flip_h = false
		$Sprite2D/ItemParent.scale.x = 1.0
	elif velocity.x < 0:
		$Sprite2D.flip_h = true
		$Sprite2D/ItemParent.scale.x = -1.0

extends CharacterBody2D
class_name unit
@export var work_range = 10
@export var work_speed = 1
@export var speed = 100
@export var damage:float = 5.0
@export var max_hp = 15
@export var cooldown = 2.0
@export var fight_range = 30


@export var type:	Global.UNIT = Global.UNIT.IMP
var target: Vector2 = Vector2(100, 100)


@onready var agent : NavigationAgent2D = %NavAgent
var priorities = [1,1,1]#tablica wskazująca priorytety danych akcji w takiej samej kolejności jak w enumie Priorities.ACTIONTYPES

var current_action: Priorities.action = null
var work_time: float

#Spawning Animation
var end_summoning = false

var spawn_anim_end = false

var hp = max_hp

func _ready():
	$SpawnSound.play()
	$AnimationPlayer.play("spawn")
	spawn_anim_end = false


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index ==1 and event.is_pressed():
			pass
			


enum STATES  { WORK, WALK, IDLE,FIGHT}
var state: STATES = STATES.IDLE
var enemy_killed = false
func _process(delta):
	#Is animation end
	if !spawn_anim_end:
		return
	#Rotation
	if velocity.x > 0:
		$Sprite.flip_h = false
		$Sprite/ItemParent.scale.x = 1.0
	elif velocity.x < 0:
		$Sprite.flip_h = true
		$Sprite/ItemParent.scale.x = -1.0
	
	match state:
		STATES.IDLE:
			
			current_action = Priorities.get_action(priorities)
			if current_action != null:
				if current_action.type == Priorities.ACTIONTYPES.FIGHT:
					if current_action.node != null:
						enemy_killed =false
						
						state=STATES.FIGHT
					
						current_action.node.died.connect(target_dead)
					else:
						Priorities.remove_action_null_node(current_action)
				else:
					
					state = STATES.WALK
		STATES.WALK:
			if $AnimationPlayer.current_animation != "walk" :
				$AnimationPlayer.play("walk")
			
			if current_action.node != null:
				target = current_action.node.position
				agent.target_position = target
				if agent.distance_to_target() < work_range :
					
					state = STATES.WORK
					$AnimationPlayer.stop()
					work_time = current_action.time 
			else:
				state = STATES.IDLE
				$AnimationPlayer.stop()
				Priorities.remove_action_null_node(current_action)
		STATES.WORK:
			if agent.distance_to_target() > work_range:
				state = STATES.WALK
			
			work_time -=delta* work_speed
			if work_time<=0:
				$gather.play()
				state = STATES.IDLE
				if current_action.node != null:
					if current_action.node.has_method("action_finished"):
						current_action.node.action_finished()
					else:
						state = STATES.IDLE
				else:
					state = STATES.IDLE
					Priorities.remove_action_null_node(current_action)
				
		STATES.FIGHT:
			if current_action != null:
				if not enemy_killed:
					if current_action.node != null:
						target = current_action.node.position
						agent.target_position = target
						if agent.distance_to_target() <=fight_range:
							attac(target)
		
				
	if state == STATES.WORK or state == STATES.WALK:
		look_for_higher_priority_job()
	
var cool = true
func attac(location : Vector2):
	if cool:
		cool = false
		%CooldownTimer.start(cooldown)
		%attac_area.global_position = location
		$AttackSound.play()
		for enemy in %attac_area.get_overlapping_bodies():
			enemy.take_damage(damage)
	
func target_dead():
	enemy_killed = true
	await get_tree().create_timer(0.5).timeout
	state = STATES.IDLE

func look_for_higher_priority_job():
	var new_job : Priorities.action = Priorities.get_action(priorities)
	if new_job != null and current_action != null:
		if priorities[new_job.type] > priorities[current_action.type]:
			if current_action != null:
				current_action.time = work_time
				Priorities.return_action(current_action)
				current_action = new_job
		else:
			Priorities.return_action(new_job)
			
			
			
			
func setStats(unitId):
	work_range = Global.units[unitId]["work_range"]
	work_speed = Global.units[unitId]["work_speed"]
	speed = Global.units[unitId]["speed"]
	damage = Global.units[unitId]["damage"]
	max_hp = Global.units[unitId]["HP"]
	hp = max_hp
	cooldown = Global.units[unitId]["cooldown"]
	fight_range = Global.units[unitId]["fight_range"]
	$Sprite.texture = Global.units[unitId]["sprite"]
	$Sprite/ItemParent/Item.texture = Global.units[unitId]["toolSprite"]
	type = unitId

func _physics_process(delta):
	#Is animation end
	if !spawn_anim_end:
		return
	if global_position.distance_to(target) >=work_range:
		var direction = agent.get_next_path_position() - global_position
		direction = direction.normalized()
		velocity = velocity.lerp(direction * speed , 0.25)
		move_and_slide()


func display_previev(node : Control):
		node.unit_selection(self)
	


func _on_animation_player_animation_finished(anim_name):
	spawn_anim_end = true
	
func take_damage(damage:float):
	hp -= damage
	if hp<=0:
		queue_free()
	


func _on_cooldown_timer_timeout():
	cool = true # Replace with function body.

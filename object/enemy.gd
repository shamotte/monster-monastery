extends CharacterBody2D

@export var  max_hp:float = 100
@export var range: float  = 30.0
@export var damage : float = 50
@export var cooldown = 2.0
@export var speed = 75.0

@onready var hp:float = max_hp

signal died
@onready var id = Priorities.get_id()
@onready var units = get_node("/root/Game/GameSpace/Units")
var target = null
@onready var agent: NavigationAgent2D = %agent
@onready var timer : Timer = %Timer

func _ready():
	Priorities.add_action(Priorities.ACTIONTYPES.FIGHT,id,$".",0.0)
	%Timer.wait_time = cooldown
	$SpawnSound.play()
	
	$AnimationPlayer.play("spawn")

func set_stats(id:int):
	max_hp = Global.enemies[id]["HP"]
	hp = max_hp
	range  = Global.enemies[id]["range"]
	damage = Global.enemies[id]["damage"]
	cooldown = Global.enemies[id]["cooldown"]
	speed = Global.enemies[id]["speed"]
	$Sprite2D/ItemParent/Item.texture = Global.enemies[id]["tool"]

func take_damage(damage:float):
	hp-=damage
	if hp<=0:
		died.emit()
		Priorities.remove_action(id)
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
		if agent.distance_to_target() <= range:
			attac(target)
		
		
	else:
		target = get_closest_unit()
		
func attac(target: Node2D):
	if cooldown:
		cooldown = false
		timer.start(cooldown)
		if target!= null:
			%attac_area.global_position = target.position
			#print("atacking")
			$AttackSound.play()
			for unit in %attac_area.get_overlapping_bodies():
				unit.take_damage(damage)


func _on_timer_timeout():
	cooldown = true
	
func _physics_process(delta):
	if target!=null:
		if global_position.distance_to(target.position) >=range:
			var direction = agent.get_next_path_position() - global_position
			direction = direction.normalized()
			velocity = velocity.lerp(direction * speed , 0.25)
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

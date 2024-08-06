extends Node2D

var resource_slot = preload("res://interface/resource_slot.tscn")
#Building Manager
var building_slot = preload("res://interface/building_slot.tscn")
var building_cost = preload("res://interface/item_slot.tscn")
var unit_slot = preload("res://interface/unit_slot.tscn")
var enemy = preload("res://object/enemy.tscn")

var resource_info
#Buildings Objects

@onready var unit_holder = %Units

# Called when the node enters the scene tree for the first time.
func _ready():
	for r in Global.resources:
		var s = resource_slot.instantiate()
		s.get_node("Sprite").texture = r.sprite
		s.get_node("Count").text = str(Global.get_resource_count(r))
		$UI/UI/Resources.add_child(s)
	resource_info = $UI/UI/Resources.get_children() 
		
	for i in Global.buildings:
		var s = building_slot.instantiate()
		s.get_node("Building").texture = i.sprite
		s.get_node("Name").text = i.name
		s.set_building_id(i.type)
		s.building = i
		for j in i.resource_cost:
			var c = building_cost.instantiate()
			c.stack = j
			s.get_node("Cost").add_child(c)

		%BuildingGrid.add_child(s)
		
	for i in Global.units:
		var s = unit_slot.instantiate()
		s.set_parameters(i)
		#s.get_node("UnitIcon").texture = i.sprite
		%UnitGrid.add_child(s)
		
		
		
var active_selection
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if %Units.get_child_count()<1:
		Engine.time_scale = 0
		%Endgame.visible = true
	else:
		Engine.time_scale = 1
		%Endgame.visible = false
	
	for i in range(Global.current_resources.size()):
		resource_info[i].get_node("Count").text = str(Global.current_resources[i])
	#for r in Global.current_resources:
	#	var s = resource_slot.instantiate()
	#	s.get_node("Sprite").texture = Global.resources[r]["sprite"]
	#	s.get_node("Count").text = str(Global.current_resources[r])
	#	s.get_node("Name").text = Global.resources[r]["name"]
	#	$UI/UI/Resources.add_child(s)
	#set_building_id(0)
	
	%UnitCount/Count.text = str(Global.unit_count)


var resource_point = preload("res://object/resource_point.tscn")
			
func mousePos():
	return get_global_mouse_position()


var enemy_scene = preload("res://object/enemy.tscn")

func _on_enemy_spawn_timer_timeout():
	for i in range(randi_range(1 + int(Global.wave_count/2), 1 + Global.wave_count*2)):
		var spawn = get_tree().get_nodes_in_group("enemy_spawner").pick_random()
		var randomEnemy = Global.enemies.pick_random() 
		var type = randomEnemy.type
		
		#Selecting enemy waves
		#print(type)
		if Global.wave_count <= 2:
			type = EnemyResource.ENEMY.PEASANT
		elif Global.wave_count <= 4:
			if type == EnemyResource.ENEMY.KNIGHT || type == EnemyResource.ENEMY.HORSEMAN || type == EnemyResource.ENEMY.ARCHER:
				type = EnemyResource.ENEMY.PEASANT
		elif Global.wave_count <= 6:
			if type == EnemyResource.ENEMY.KNIGHT:
				type = EnemyResource.ENEMY.PEASANT
			if type == EnemyResource.ENEMY.HORSEMAN:
				type = EnemyResource.ENEMY.PRIEST
		elif Global.wave_count <= 8:
			if type == EnemyResource.ENEMY.KNIGHT:
				type = EnemyResource.ENEMY.PRIEST
			if type == EnemyResource.ENEMY.HORSEMAN:
				type = EnemyResource.ENEMY.ARCHER
		elif Global.wave_count <= 10:
			if type == EnemyResource.ENEMY.HORSEMAN:
				type = EnemyResource.ENEMY.ARCHER
		elif Global.wave_count <= 12:
			if type == EnemyResource.ENEMY.HORSEMAN:
				type = EnemyResource.ENEMY.KNIGHT
		elif Global.wave_count <= 14:
			pass
		elif Global.wave_count <= 16:
			if type == EnemyResource.ENEMY.PEASANT:
				type = EnemyResource.ENEMY.PRIEST
		elif Global.wave_count <= 18:
			if type == EnemyResource.ENEMY.PEASANT:
				type = EnemyResource.ENEMY.ARCHER
			if type == EnemyResource.ENEMY.PRIEST:
				type = EnemyResource.ENEMY.ARCHER
		elif Global.wave_count <= 24:
			if type == EnemyResource.ENEMY.PEASANT:
				type = EnemyResource.ENEMY.ARCHER
			if type == EnemyResource.ENEMY.PRIEST:
				type = EnemyResource.ENEMY.KNIGHT
		elif Global.wave_count <= 26:
			if type == EnemyResource.ENEMY.PEASANT:
				type = EnemyResource.ENEMY.KNIGHT
			if type == EnemyResource.ENEMY.PRIEST:
				type = EnemyResource.ENEMY.KNIGHT
		elif Global.wave_count <= 28:
			if type == EnemyResource.ENEMY.PEASANT:
				type = EnemyResource.ENEMY.HORSEMAN
			if type == EnemyResource.ENEMY.PRIEST:
				type = EnemyResource.ENEMY.KNIGHT
		elif Global.wave_count >= 30:
			if type == EnemyResource.ENEMY.PEASANT:
				type = EnemyResource.ENEMY.HORSEMAN
			if type == EnemyResource.ENEMY.PRIEST:
				type = EnemyResource.ENEMY.HORSEMAN
				
		
		var e = enemy_scene.instantiate()
		e.global_position = spawn.global_position
		e.set_stats(Global.enemies[type])
		$GameSpace/Enemies.add_child(e)
		
	$WaveSpawnSound.play()
	Global.wave_count += 1
	%WaveCount.visible = true
	%WaveCount/Count.text = "Wave " + str(Global.wave_count)

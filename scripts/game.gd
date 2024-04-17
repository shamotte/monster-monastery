extends Node2D

var resource_slot = preload("res://interface/resource_slot.tscn")
var item_slot = preload("res://interface/item_slot.tscn")
#Building Manager
var building_slot = preload("res://interface/building_slot.tscn")
var building_cost = preload("res://interface/building_cost.tscn")
var unit_slot = preload("res://interface/unit_slot.tscn")
var enemy = preload("res://object/enemy.tscn")

var resource_info
#Buildings Objects


# Called when the node enters the scene tree for the first time.
func _ready():
	for r in Global.current_resources:
		var s = resource_slot.instantiate()
		s.get_node("Sprite").texture = Global.resources[r]["sprite"]
		s.get_node("Count").text = str(Global.current_resources[r])
		$UI/UI/Resources.add_child(s)
	resource_info = $UI/UI/Resources.get_children() 
		
	for i in Global.buildings:
		var s = building_slot.instantiate()
		s.get_node("Building").texture = Global.buildings[i]["sprite"]
		s.building = i
		for j in range(Global.buildings[i]["resource_type"].size()):
			var c = building_cost.instantiate()
			c.get_node("Sprite").texture = Global.resources[Global.buildings[i]["resource_type"][j]]["sprite"]
			c.get_node("Count").text = str(Global.buildings[i]["resource_cost"][j])
			s.get_node("Cost").add_child(c)
		$UI/UI/Building/Panel/BuildingsList/GridContainer.add_child(s)
		
	for i in Global.units:
		var s = unit_slot.instantiate()
		s.get_node("UnitIcon").texture = Global.units[i]["sprite"]
		s.units = i
		for j in range(Global.units[i]["resource_type"].size()):
			var c = building_cost.instantiate()
			c.get_node("Sprite").texture = Global.resources[Global.units[i]["resource_type"][j]]["sprite"]
			c.get_node("Count").text = str(Global.units[i]["resource_cost"][j])
			s.get_node("Cost").add_child(c)
		$UI/UI/Building/Panel/SpawnList/GridContainer.add_child(s)
		
		
var active_selection
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if %Units.get_child_count()<1:
		Engine.time_scale = 0
		%Endgame.visible = true
	
	for i in range(Global.current_resources.size()):
		resource_info[i].get_node("Count").text = str(Global.current_resources[i])
	#for r in Global.current_resources:
	#	var s = resource_slot.instantiate()
	#	s.get_node("Sprite").texture = Global.resources[r]["sprite"]
	#	s.get_node("Count").text = str(Global.current_resources[r])
	#	s.get_node("Name").text = Global.resources[r]["name"]
	#	$UI/UI/Resources.add_child(s)
	#set_building_id(0)


var resource_point = preload("res://object/resource_point.tscn")
			
func mousePos():
	return get_global_mouse_position()


var enemy_scene = preload("res://object/enemy.tscn")
var timer_timeouts = 0

func _on_enemy_spawn_timer_timeout():
	for i in range(randi_range(0, 1 + timer_timeouts * 2)):
		var spawn = get_tree().get_nodes_in_group("enemy_spawner").pick_random()
		var type = Global.enemies.keys().pick_random()
		#Selecting enemy waves
		#print(type)
		if timer_timeouts <= 5:
			type = Global.ENEMY.PEASANT
		elif timer_timeouts <= 10:
			if type == Global.ENEMY.KNIGHT || type == Global.ENEMY.HORSEMAN:
				type = Global.ENEMY.PEASANT
		elif timer_timeouts <= 15:
			if type == Global.ENEMY.KNIGHT:
				type = Global.ENEMY.PEASANT
			if type == Global.ENEMY.HORSEMAN:
				type = Global.ENEMY.PRIEST
		elif timer_timeouts <= 20:
			if type == Global.ENEMY.HORSEMAN:
				type = Global.ENEMY.PRIEST
		elif timer_timeouts <= 25:
			if type == Global.ENEMY.HORSEMAN:
				type = Global.ENEMY.KNIGHT
		
		var e = enemy_scene.instantiate()
		e.global_position = spawn.global_position
		e.get_node("Sprite2D").texture = Global.enemies[type]["sprite"]
		e.set_stats(type)
		$GameSpace/Enemies.add_child(e)
		
	timer_timeouts += 1

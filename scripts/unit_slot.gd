extends Control

var unit: UnitResource
var c

var unit_info

var cost_slot = preload("res://interface/item_slot.tscn")
var stat_slot = preload("res://interface/stat_slot.tscn")

enum statistics {HP,ATTACK,WORKTIME,ATTACKRANGE,COOLDOWN,WORKRANGE,SPEED}

func _ready():
	unit_info = get_tree().get_first_node_in_group("UnitSpawnInfo")
	set_info_panel()

# Called when the node enters the scene tree for the first time.
func set_parameters(newUnit: UnitResource):
	unit = newUnit
	$UnitIcon.texture = unit.sprite
	$Name.text = unit.name

	for i in unit.resource_cost:
		var c = cost_slot.instantiate()
		c.stack = i
		$Cost.add_child(c)
	
	c = $Cost.get_children()

func _process(delta):
	var slotnum = 0
	for i in unit.resource_cost:
		if Global.current_resources[i.type] < i.count:
			c[slotnum].get_node("Count").modulate = "#cc425e"
		else:
			c[slotnum].get_node("Count").modulate = "#ffffff"
		slotnum += 1
			
func _on_button_pressed():
	
	#checking if player can buy unit
	if !Global.check_resources(unit.resource_cost):
		return

	var manager = get_tree().get_first_node_in_group("Units")
	manager.set_unit_id(unit.type)
	var managerUI = get_tree().get_first_node_in_group("BuildingUI")
	managerUI.hide_panel(true)
	
func _on_button_mouse_entered():
	set_info_panel()
	
#Set values for info panel
func set_info_panel():
	#setting data
	unit_info.get_node("Name").text = unit.name
	unit_info.get_node("Image").texture = unit.sprite
	#remove older cost
	for i in unit_info.get_node("Cost").get_children():
		i.queue_free()
	#adding new cost
	for i in unit.resource_cost:
		var c = cost_slot.instantiate()
		c.stack = i
		unit_info.get_node("Cost").add_child(c)
	#Units Stats
	#remove older stats
	for i in unit_info.get_node("Statistics").get_children():
		i.queue_free()
	#adding new cost
	for i in statistics:
		var s = stat_slot.instantiate()
		s.set_HP(unit.hp)
		#s.set_hp(unit.hp)
		
		match statistics[i]:
			statistics.HP:
				s.set_HP(unit.hp)
			statistics.ATTACK:
				s.set_attack(unit.damage)
			statistics.SPEED:
				s.set_speed(unit.speed)
			statistics.ATTACKRANGE:
				s.set_attackRange(unit.fight_range)
			statistics.COOLDOWN:
				s.set_attackCooldown(unit.cooldown)
			statistics.WORKRANGE:
				s.set_workRange(unit.work_range)
			statistics.WORKTIME:
				s.set_workTime(unit.work_speed)
		unit_info.get_node("Statistics").add_child(s)
	
	
	#TODO special abilities info 
	
	
	
	
	
	
	

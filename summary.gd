extends Control

@export var unit_summary : PackedScene
@export var resource_slot : PackedScene

func _on_button_pressed() -> void:
	Global.restart_game()

func set_survived_waves(waves : int):
	$Panel/Description.text = "All your minions were defeated! You survived " + str(waves) +" wave(s).\nThank you for playing!"

func set_summoned_units(unit_count : int):
	$Panel/SummonedUnits.text = "Units Summoned: "+str(unit_count)
	
func set_killed_units(unit_killed : int):
	$Panel/KilledEnemies.text = "Enemies Killed: "+str(unit_killed)
	
func set_gained_resources(resources_count : int):
	$Panel/GainedResources.text = "Resources Gained: "+str(resources_count)
	
func set_enemies(enemies_count : Array[int]):
	#remove older
	for i in $Panel/Enemies.get_children():
		i.queue_free()
	#add new
	for i in len(Global.enemies):
		if enemies_count[i] == 0:
			continue
		var e = unit_summary.instantiate()
		e.set_number(enemies_count[i])
		e.set_image(Global.enemies[i].sprite)
		$Panel/Enemies.add_child(e)
	
func set_resources(resources_type : Array[int]):
	#remove older
	for i in $Panel/Resources.get_children():
		i.queue_free()
	#add new
	for i in len(Global.resources):
		if resources_type[i] == 0:
			continue
		var r = resource_slot.instantiate()
		r.set_amount(resources_type[i])
		r.set_image(Global.resources[i].sprite)
		$Panel/Resources.add_child(r)
		
func set_units(unit_count : Array[int]):
	for i in $Panel/Units.get_children():
		i.queue_free()
	#add new
	for i in len(Global.units):
		if unit_count[i] == 0:
			continue
		var u = unit_summary.instantiate()
		u.set_number(unit_count[i])
		u.set_image(Global.units[i].sprite)
		$Panel/Units.add_child(u)
	

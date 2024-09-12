extends Control


func _on_button_pressed() -> void:
	Global.restart_game()

func set_survived_waves(waves : int):
	$Panel/Description.text = "GAME OVER\nAll your minions were defeated! You survived " + str(waves) +" waves\nThank you for playing!"

func set_summoned_units(unit_count : int):
	$Panel/SummonedUnits.text = "Summoned Units: "+str(unit_count)
	
func set_killed_units(unit_killed : int):
	$Panel/KilledEnemies.text = "Killed Enemies: "+str(unit_killed)
	
func set_gained_resources(resources_count : int):
	$Panel/GainedResources.text = "Gained Resources: "+str(resources_count)
	

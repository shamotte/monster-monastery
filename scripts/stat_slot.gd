extends Control

#TODO dokończyć ustawianie statystyk

func set_HP(HPValue: float):
	$Sprite.texture = load("res://sprites/UI/Demon Hearth.png")
	$Count.text = str(HPValue)
	
func set_attack(attackValue: float):
	$Sprite.texture = load("res://sprites/UI/demon_sword2.png")
	$Count.text = str(attackValue)
	
func set_speed(speedValue: float):
	$Sprite.texture = load("res://sprites/UI/DemonLeg.png")
	$Count.text = str(speedValue)
	
func set_attackRange(attackRangeValue: float):
	$Sprite.texture = load("res://sprites/UI/firingStaff.png")
	$Count.text = str(attackRangeValue)
	
func set_attackCooldown(attackCooldownValue: float):
	$Sprite.texture = load("res://sprites/UI/DemonHourglass.png")
	$Count.text = str(attackCooldownValue)
	
func set_workRange(workRangeValue: float):
	$Sprite.texture = load("res://sprites/UI/FiringAtTree.png")
	$Count.text = str(workRangeValue)
	
func set_workTime(workTimeValue: float):
	$Sprite.texture = load("res://sprites/UI/Pickaxe.png")
	$Count.text = str(workTimeValue)

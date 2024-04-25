extends Control

#TODO dokończyć ustawianie statystyk

func set_HP(HPValue: int):
	$Sprite.texture = load("res://sprites/UI/demon_sword2.png")
	$Count.text = str(HPValue)
	
func set_attack(attackValue: int):
	$Sprite.texture = load("res://sprites/UI/demon_sword2.png")
	$Count.text = str(attackValue)
	
func set_speed(speedValue: int):
	$Sprite.texture = load("res://sprites/UI/demon_sword2.png")
	$Count.text = str(speedValue)
	
func set_attackRange(attackRangeValue: int):
	$Sprite.texture = load("res://sprites/UI/demon_sword2.png")
	$Count.text = str(attackRangeValue)
	
func set_attackCooldown(attackCooldownValue: int):
	$Sprite.texture = load("res://sprites/UI/demon_sword2.png")
	$Count.text = str(attackCooldownValue)
	
func set_workRange(workRangeValue: int):
	$Sprite.texture = load("res://sprites/UI/demon_sword2.png")
	$Count.text = str(workRangeValue)
	
func set_workTime(workTimeValue: int):
	$Sprite.texture = load("res://sprites/UI/demon_sword2.png")
	$Count.text = str(workTimeValue)

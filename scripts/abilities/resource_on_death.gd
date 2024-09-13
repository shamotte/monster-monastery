extends Ability
class_name ResourceOnDeath
@export  var resources : Array[ResourceStack]


func on_death():
	Global.add_resources(resources)

@tool
class_name projectile_shooter
extends Ability
@export var cooldown= 5.0
@export var projectile:PackedScene:
	set(value):
		projectile_data.clear()
		if value == null:
			projectile = null
			return
		projectile_data.clear()
		var inst = value.instantiate()
		var properties : Array[String] = []
		for v in inst.get_script().get_script_property_list():
			properties.append(v["name"])
		var base = Area2D.new()
		for v in base.get_property_list():
			properties.erase(v["name"])
		projectile = value
		for x in properties:
			projectile_data.get_or_add(x,null)
		
@export var speed : float = 1
@export var range :float = 300
@export var sprite : Texture2D
@export var damage : float

@export var spawn_radius : int = 1

@export var projectile_data :Dictionary= {}


var time_left = 0
func fight_process(delta):
	time_left -= delta
	if time_left <= 0:
		if ovner.global_position.distance_to(ovner.target_global_position) < range:
			time_left = cooldown

			var proj: Area2D = projectile.instantiate()
			
			
			proj.collision_mask = to_target
			proj.get_node("Sprite2D").texture = sprite
			if proj.has_method("set_damage"):
				proj.set_damage(damage)
			proj.set("target",ovner.target)
			var direction = (ovner.target_global_position - ovner.global_position).normalized()
			proj.velocity = direction *speed
			proj.global_position = ovner.global_position + Vector2(randf_range(-spawn_radius,spawn_radius),randf_range(-spawn_radius,spawn_radius))
			for name in projectile_data:
				if projectile_data[name] != null:
					proj.set(name,projectile_data[name])
			ProjectileOverseeer.add_child(proj)
		

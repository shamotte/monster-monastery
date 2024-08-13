class_name projectile_shooter
extends Ability
@export var cooldown= 5.0
@export var projectile:PackedScene
@export var speed : float = 1
@export var range :float = 300
@export var sprite : Texture2D
@export var damage : float

@export var spawn_radius : int = 1

var time_left = 0
func fight_process(delta):
	time_left -= delta
	if time_left <= 0:
		if ovner.global_position.distance_to(ovner.target_global_position) < range:
			time_left = cooldown

			var proj: Area2D = projectile.instantiate()
			proj.collision_mask = to_target
			proj.get_node("Sprite2D").texture = sprite
			proj.set_damage(damage)
			var direction = (ovner.target_global_position - ovner.global_position).normalized()
			proj.velocity = direction *speed
			proj.global_position = ovner.global_position + Vector2(randf_range(-spawn_radius,spawn_radius),randf_range(-spawn_radius,spawn_radius))
			ProjectileOverseeer.add_child(proj)
		

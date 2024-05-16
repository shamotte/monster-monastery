class_name MeleeAttack
extends Ability
@export var  cooldown : float
@export var visual_effect :PackedScene
@export var size : Vector2 = Vector2(32,32)
@export var damage: float = 10

var time_left = 0
func fight_process(delta):
	time_left -= delta
	if time_left <= 0:
		time_left = cooldown
		print("mele attack")
		var effect = visual_effect.instantiate()
		var direction = (ovner.target_global_position - ovner.global_position).normalized()
		effect.global_position = ovner.global_position + direction * 30
		effect.rotation = Vector2.UP.angle_to(direction)
		print(effect.rotation)
		var space:PhysicsDirectSpaceState2D = ProjectileOverseeer.get_world_2d().direct_space_state
		var parameters : PhysicsShapeQueryParameters2D =  PhysicsShapeQueryParameters2D.new()
		var shape = RectangleShape2D.new()
		shape.size = size
		parameters.shape = shape
		parameters.collide_with_areas = false
		parameters.collision_mask = 64
		parameters.transform = Transform2D(Vector2.UP.angle_to(direction),ovner.target_global_position)
		
		var result = space.intersect_shape(parameters)
		
		for col in result:
			col.collider.take_damage(damage)
		
		ProjectileOverseeer.add_child(effect);
		await ProjectileOverseeer.get_tree().create_timer(0.5).timeout
		effect.queue_free()

class_name ShockWave
extends Ability
@export var  cooldown : float
@export var visual_effect :PackedScene
@export var damage: float = 10
@export var range:float = 30 :
	get:
		return range /2
var time_left = 0
func fight_process(delta):
	time_left -= delta
	if time_left <= 0:
		
		if ovner.global_position.distance_to(ovner.target_global_position) < range:
			time_left = cooldown
			var effect = visual_effect.instantiate()
			var direction = (ovner.target_global_position - ovner.global_position).normalized()
			effect.global_position = ovner.global_position
			var space:PhysicsDirectSpaceState2D = ProjectileOverseeer.get_world_2d().direct_space_state
			var parameters : PhysicsShapeQueryParameters2D =  PhysicsShapeQueryParameters2D.new()
			var shape := CircleShape2D.new()
			shape.radius = range
			
			parameters.shape = shape
			parameters.collide_with_areas = false
			parameters.collision_mask = to_target
			parameters.transform = Transform2D(Vector2.UP.angle_to(direction),ovner.global_position)
		
			var result = space.intersect_shape(parameters)
			
			for col in result:
				col.collider.take_damage(damage)
			
			ProjectileOverseeer.add_child(effect);

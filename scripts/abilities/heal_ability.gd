extends Ability
class_name heal

@export var cooldown = 1
var timer: float = 0
@export var projectile:PackedScene
@export var healing:float =10
var healing_area : Area2D
var to_target_actual: int = 64
var range : int  = 200


func init(node : Node2D):
	ovner = node
	if to_target == 64:
		to_target_actual = 128
	else:
		to_target_actual = 64
		
	healing_area = Area2D.new();
	healing_area.collision_mask = to_target_actual
	healing_area.collision_layer = 0
	var collision : CollisionShape2D = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = range
	collision.shape = shape
	
	
	healing_area.add_child(collision)
	
	node.add_child(healing_area)


func fight_process(delta):
	timer -= delta;
	if timer <=0:
		timer = cooldown
		var bodies :=  healing_area.get_overlapping_bodies()
		bodies.erase(ovner)
		var target
		if bodies.size() > 0:
			target = bodies[0]
		
			var proj: Area2D = projectile.instantiate()
		
			proj.healing = healing
			proj.target = target
		
		
			proj.global_position = ovner.global_position
			ProjectileOverseeer.add_child(proj)

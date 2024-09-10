extends GPUParticles2D

@export var target: Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	emitting = true
	if is_instance_valid(target):
		process_material.set("emission_shape_offset", to_local(target.global_position))
		
	else:
		emitting = false
		process_material.set("emission_shape_offset", Vector3.ZERO)

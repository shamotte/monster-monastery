@tool
extends GPUParticles2D

@export var target: Node2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(target):
		set("emission_shape_offset",target.position)
		print("xx")

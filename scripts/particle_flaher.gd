extends Node2D

@export var shroom : PackedScene
@export var life_drain : PackedScene
@export var exsplosive_projectile : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var sh = shroom.instantiate()
	add_child(sh)
	
	
	for child in sh.get_children():
		if child is GPUParticles2D:
			child.emitting = true
			
	var ld = life_drain.instantiate()
	add_child(ld)
	
	
	
	for child in ld.get_children():
		if child is GPUParticles2D:
			child.emitting = true
	
	var ep = exsplosive_projectile.instantiate()
	add_child(ep)
	
	for child in ep.get_children():
		if child is GPUParticles2D:
			child.emitting = true
			
	await null
	await  null
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

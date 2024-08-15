extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready():
	emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_swing_timeout():
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play("Attack")

func _on_life_time_timeout():
	queue_free()



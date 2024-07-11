extends Sprite2D

@export var attack_duration : float 	#how long streak will appear

# Called when the node enters the scene tree for the first time.
func _ready():
	#texture = null
	$AnimSprite.play("Attack")
	await get_tree().create_timer(attack_duration).timeout
	queue_free() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

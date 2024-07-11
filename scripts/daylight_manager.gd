extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	
func _physics_process(delta):
	if $AnimationPlayer.current_animation != "":
		var daylight_progress = $AnimationPlayer.current_animation_position / $AnimationPlayer.current_animation_length
		print(daylight_progress)
		
		for shadow in get_tree().get_nodes_in_group("shadow"):
			shadow.set_skew(deg_to_rad(lerp(-90.0, 90.0, daylight_progress * 2))) # 2 Full skew cycles per day
			shadow.flip_v = 1
			shadow.set_position(Vector2(-16, 0).rotated(TAU * daylight_progress) + Vector2(0, 16))
			shadow.set_offset(Vector2(0, shadow.texture.get_height()))
			
	
func start_cycle():
	visible = true
	$AnimationPlayer.play("cycle")
	$AnimationPlayer.speed_scale = 10.0/12.0

func _on_animation_player_animation_finished(anim_name):
	$AnimationPlayer.play("cycle")

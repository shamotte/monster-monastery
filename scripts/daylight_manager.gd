extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	
func start_cycle():
	visible = true
	$AnimationPlayer.play("cycle")
	$AnimationPlayer.speed_scale = 10/120

func _on_animation_player_animation_finished(anim_name):
	$AnimationPlayer.play("cycle")

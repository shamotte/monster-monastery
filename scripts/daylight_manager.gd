extends CanvasLayer

@export var night_start : float ## value of daylight progress when night begans 
var night : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	
func _physics_process(delta):
	if $AnimationPlayer.current_animation != "":
		var daylight_progress = $AnimationPlayer.current_animation_position / $AnimationPlayer.current_animation_length

		for shadow in get_tree().get_nodes_in_group("shadow"):
			shadow.set_skew(deg_to_rad(lerp(-90.0, 90.0, daylight_progress)))
			shadow.set_position(Vector2(shadow.texture.get_height() / 2, 0).rotated(PI * daylight_progress) + Vector2(0, shadow.texture.get_height() / 2))
			shadow.set_offset(Vector2(0, -shadow.texture.get_height()))
		if daylight_progress >= night_start:
			night = true
			return
		night = false
	
func start_cycle():
	visible = true
	$AnimationPlayer.play("cycle")
	$AnimationPlayer.speed_scale = 10.0/120.0
	#$AnimationPlayer.speed_scale = 10.0/10.0 	#For testing
	
func is_night():
	return night 
	
func _on_animation_player_animation_finished(anim_name):
	$AnimationPlayer.play("cycle")

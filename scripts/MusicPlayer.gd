extends Node

var volume_normal = 0.0
var volume_battle = -20.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Normal.play()
	$Battle.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var in_battle = get_tree().get_nodes_in_group("enemy").size() >= 3 

	volume_normal = lerp(volume_normal, -20.0 if in_battle else 0.0, 0.005)
	volume_battle = lerp(volume_battle, 0.0 if in_battle else -20.0, 0.005)

	$Normal.volume_db = volume_normal * Global.volume
	$Battle.volume_db = volume_battle * Global.volume


func _on_audio_stream_player_finished():
	$Normal.play()


func _on_battle_finished():
	$Battle.play()

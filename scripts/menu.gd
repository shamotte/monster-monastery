extends CanvasLayer

func _ready():
	$Container/TitleOrigin/AnimationPlayer.play("move")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$Container/TitleOrigin/AnimationPlayer.play("move")


func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	Global.game_begin()

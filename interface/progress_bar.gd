extends ProgressBar

func show_bar(show : bool):
	visible = show
	
func start_timer():
	$HideProgressBar.start()

func _on_hide_progress_bar_timeout() -> void:
	visible = false

extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = true
	%UnitCount/Count.text = str(0)
	%WaveCount.visible = false
	

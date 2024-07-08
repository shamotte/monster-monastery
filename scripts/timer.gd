extends Panel

@export var counter : Node
@export var timer : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_timer()

func set_timer():
	var minutes = int(round(timer.time_left))/60
	var seconds = int(round(timer.time_left))%60
	if(seconds < 10):
		seconds = "0"+str(seconds)
	#counter.text = str(minutes)
	counter.text = str(minutes) + ":" + str(seconds)

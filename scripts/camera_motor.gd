extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var mouse_movement:bool = false
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index ==1 and event.is_pressed():
			mouse_movement = true
		elif event.button_index ==1 and not event.is_pressed():
			mouse_movement = false
	if event is InputEventMouseMotion and mouse_movement:
		position -= event.relative
		
	position.x = clamp(position.x, -Global.map_width/2 + 320, Global.map_width/2 - 320)
	position.y = clamp(position.y, -Global.map_height/2 + 180, Global.map_height/2 - 180)
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

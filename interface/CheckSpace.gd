extends Sprite2D

var in_building_area = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if is_overalaping():
		modulate = "#ff0000"
	else:
		modulate = "#ffffff"

func is_overalaping():
	var overlap = false
	if $CheckPointer.get_overlapping_areas().size() != 1:
		overlap = true
	elif $CheckPointer.get_overlapping_areas().size() == 1 and !in_building_area: 
		overlap = true
	return overlap

func _on_building_area_area_entered(area):
	in_building_area = true


func _on_building_area_area_exited(area):
	in_building_area = false

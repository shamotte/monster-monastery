extends Control
var priority:int
var index:int
@export var max_number:int = 5
@export var label :String
@export var texture :Texture

signal value_changed(index, new_priority)
# Called when the node enters the scene tree for the first time.
func _ready():
	$Icon.texture = texture
	$Label.text = label


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func change_label(name : int):
	#$Label.text = name
	$Label.text = Priorities.actions[name]["name"]
	#$Label.text = ""
	
func change_icon(name : int):
	#$Label.text = name
	$Icon.texture = Priorities.actions[name]["sprite"]


func change_priority(n: int):
	priority = n
	$priority_elem.text = str(priority)
	
	
func _on_priority_elem_pressed():
	priority += 1
	if priority >=max_number:
		priority = 0
	$priority_elem.text = str(priority)
	value_changed.emit(index,priority)
	

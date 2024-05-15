extends Control
var priority:int			#Priority Value
var index:int
var num_slot:int			#slot number in grid
var group: PriorityTable	#Which group represents 
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
	label = Priorities.actions[name]["name"]
	$Label.text = label
	#$Label.text = ""
	
func change_icon(name : int):
	texture = Priorities.actions[name]["sprite"]
	$Icon.texture = texture

func change_priority(n: int):
	priority = n
	$priority_elem.text = str(priority)
	
func set_group(newGroup : PriorityTable,number : int):
	group = newGroup
	num_slot = number
		
func _on_priority_elem_pressed():
	priority += 1
	if priority >=max_number:
		priority = 0
	$priority_elem.text = str(priority)
	group.increment_priority(num_slot)
	value_changed.emit(index,priority)
	


func _on_group_identifier_pressed():
	pass # Replace with function body.

extends Control
var caounter:int			#caounter Value	#Which group represents 
@export var max_number:int = 5
@export var label :String

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = label

signal new_value(int)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$priority_elem.text = str(caounter)


func change_label(name : int):
	#$Label.text = name
	label = Priorities.actions[name]["name"]
	$Label.text = label
	#$Label.text = ""
	


func change_priority(n: int):
	caounter = n
	$priority_elem.text = str(caounter)

		
func _on_priority_elem_pressed():
	print("aaaa")
	caounter += 1
	if caounter >=max_number:
		caounter = 0
	$priority_elem.text = str(caounter)
	new_value.emit(caounter)
	


func _on_group_identifier_pressed():
	pass # Replace with function body.

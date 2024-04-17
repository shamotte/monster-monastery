extends Control

var unit: UnitResource
var c

var cost_slot = preload("res://interface/item_slot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$UnitIcon.texture = unit.sprite
	$Name.text = unit.name

	for i in unit.resource_cost:
		var c = cost_slot.instantiate()
		c.stack = i
		$Cost.add_child(c)
	
	c = $Cost.get_children()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in unit.resource_cost:
		if Global.current_resources[i.type] < i.count:
			c[i].get_node("Count").modulate = "#cc425e"
		else:
			c[i].get_node("Count").modulate = "#ffffff"
			
func _on_button_pressed():
	
	#checking if player can buy unit
	for i in unit.resource_cost:
		if Global.current_resources[i.type] < i.count:
			return

	var manager = get_tree().get_first_node_in_group("Units")
	manager.set_unit_id(0)
	var managerUI = get_tree().get_first_node_in_group("BuildingUI")
	managerUI.hide_panel(true)

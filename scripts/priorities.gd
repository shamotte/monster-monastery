extends Node






enum ACTIONTYPES {GATHER=0,CRAFT,FIGHT}

var actions = {
	ACTIONTYPES.GATHER: {
		"name": "Gather",
		"sprite": preload("res://sprites/UI/axe32.png")
	},
	ACTIONTYPES.CRAFT: {
		"name": "Craft",
		"sprite": preload("res://sprites/UI/crafting.png")
	},
	ACTIONTYPES.FIGHT: {
		"name": "Fight",
		"sprite": preload("res://sprites/UI/fight.png")
	}
}



func _ready():
	aveilable.resize(3)

func add_self_to_available_actions(object, action_type : ACTIONTYPES):
	aveilable[action_type].push_back(object)
	
	
func remove_self_from_actions(object, action_type : ACTIONTYPES):
	aveilable[action_type].erase(object)
	
		
var aveilable : Array[Array]

var id = 0
func get_id() -> int:
	id+=1
	return id
	

	

func get_best_action(unit : Unit) -> Node2D:
	var unit_position:Vector2 = unit.position
	var best_action : Node2D = null
	var value :float = 0
	var multiplayer = 1
	for actiontype in ACTIONTYPES:
		multiplayer = 1
		for ob in aveilable[actiontype]:
			if ob != null:
				var current_value : float = 0
				current_value +=  clamp(1000_000 - unit_position.distance_squared_to(ob.position),0,1000_000)
				current_value +=  clamp(5 - ob.units_working_on_this,0,5) * 5000_0
				current_value *= multiplayer
				if current_value > value:
					best_action = ob
				value = current_value
		multiplayer-=1
	
	
	if best_action != null:
		best_action.units_working_on_this +=1 #unit will consider certen action worse if there is somebody already working on this action
	return best_action

func get_fight_action(unit : Unit):
	var unit_position:Vector2 = unit.position
	var best_action : Node2D = null
	var value :float = 0
	for ob: Enemy in aveilable[ACTIONTYPES.FIGHT]:
		if unit_position.distance_squared_to(ob.position) < 1500:
			
			var current_value =  clamp(5 - ob.units_working_on_this,0,5) 
			if current_value > value:
				best_action = ob
				value = current_value
	return best_action
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

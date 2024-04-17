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
	
func get_action_icon(index:int):

	match index:
		0: return "Gather"
		1: return "Craft"
		2: return "Fight"
	return "error_string"
		


class action:
	var type: ACTIONTYPES
	var id : int
	var node :Node2D
	var time : float
	func _init(t,i,n,ti):
		type = t
		id = i
		node = n
		time = ti

var aveilable = [] 

var id = 0
func get_id() -> int:
	id+=1
	return id
	

var mutex:Mutex = Mutex.new()
func add_action(type : ACTIONTYPES,id : int, node :Node2D,time : float):
	aveilable.append(action.new(type,id,node,time))

func remove_action(id:int):
	for elem in aveilable:
		if elem.id == id:
			aveilable.erase(elem)
			break
func remove_action_null_node(act :action):
	aveilable.erase(act)
	
func return_action(act: action):
	aveilable.append(act)
	
func get_action(a)->action:
	mutex.lock()
	var b = aveilable.filter(func(n) : return a[n.type]>0)
	b.sort_custom(func(l,r):return a[l.type]>a[r.type])
	if not b.is_empty():
		if b[0].type == ACTIONTYPES.FIGHT:
			mutex.unlock()
			return b[0]
		else:
			var pom = b.pop_front()
			aveilable.erase(pom)
			mutex.unlock()
			return pom
	mutex.unlock()
	return null
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

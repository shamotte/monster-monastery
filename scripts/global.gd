extends Node

const map_width = 1920
const map_height = 1080

var volume: float = 1.0

var unit_count = 0
var wave_count = 0




var resources: Array[ResourceResource] = []
var units: Array[UnitResource] = []
var buildings: Array[BuildingResource] = []
var enemies: Array[EnemyResource] = []


var current_resources: Array[int] = []
var current_groups: Array[PriorityTable] = []


@export var work_range = 10
@export var work_speed = 1
@export var speed = 100
@export var damage:float = 5.0
@export var max_hp = 100
@export var cooldown = 2.0
@export var fight_range = 30

#summary
var summoned_units : int
var units_type : Array[int]
var waves_survived : int
var enemies_killed : int
var enemies_type : Array[int]
var resources_gained : int
var resource_type : Array[int]


enum statistics {HP,ATTACK,WORKTIME,ATTACKRANGE,COOLDOWN,WORKRANGE,SPEED}

func dir_contents(directory :String, extension:String) -> Array[String]:
	var dir = DirAccess.open(directory)
	if !dir:
		print("cannot open directory:", directory, " to load files")
		return []
	
	var files : Array[String] = []
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.ends_with(extension):
			if file_name.ends_with(".remap"):
				file_name = file_name.replace(".remap","")
				print(file_name)
			files.push_back(file_name)
			
		file_name = dir.get_next()
	return files
	
func load_resources_to_array(array : Array,directory,extension):
	var files :Array[String] = dir_contents(directory,extension)
	array.resize(len(files))
	var x = 0
	for i in range(len(files) ):
		var file = ResourceLoader.load(directory + files[i])
		if file!= null:
			array[file.type] = file
			x+=1
	print("LOADED ",x, " resources from directory :",directory)

func _ready():
	pass
	#game_begin()
	

#func _process(delta):
	#if Input.is_action_just_pressed("fullscreen"):
		#var get_mode = DisplayServer.window_get_mode()
		#if get_mode != DisplayServer.WINDOW_MODE_FULLSCREEN and get_mode != DisplayServer.WINDOW_MODE_MAXIMIZED:
			#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		#else:
			#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
func add_resources(resources: Array[ResourceStack]) -> void:
	for resource in resources:
		current_resources[resource.type] += resource.count
		resources_gained += 1 
		resource_type[resource.type] += 1
		
	
#check is player can buy something
func check_resources(resources: Array[ResourceStack]) -> bool:
	for resource in resources:
		if current_resources[resource.type] < resource.count:
			return false
	return true
#subtract resources
func subtract_resources(resources: Array[ResourceStack]):
	for resource in resources:
			current_resources[resource.type] -= resource.count
#check and subtract if can pay 
func check_and_subtract_resources(resources: Array[ResourceStack]) -> bool:
	for resource in resources:
		if current_resources[resource.type] < resource.count:
			return false
	for resource in resources:
		current_resources[resource.type] -= resource.count
	return true	
#
func get_resource_count(resource_type : ResourceResource) -> int:
	return current_resources[resource_type.type]
#wiem, że dogadaliśmy się że dla konswkwencji funkcja get_resource_count powinna przyjmowac jako argument resourceresource
#ale jest to nie wygodne w użyciu, dlatego pozostawiam tutaj także wariant wcześniejszy pzyjmujący enuma z jakże pięknym dużym E na końcu
#konwencje można zmienić oczywiście
func get_resource_countE(resource_type : ResourceResource.RESOURCE) -> int:
	return current_resources[resource_type]
	
#Only for testing
func set_all_resources(amount: int):
	for i in range(current_resources.size()):
		current_resources[i] = amount
		
func enemy_killed(enemy : EnemyResource):
	enemies_killed += 1
	enemies_type[enemy.type] += 1
	
func unit_summoned(unit : UnitResource):
	if unit.type != UnitResource.UNIT.SUMMONED:
		summoned_units += 1
		units_type[unit.type] += 1
		
func restart_game():
	current_groups = []				#Restarting groups
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	
func game_begin():
	wave_count = 0
	summoned_units = 0
	waves_survived = 0
	enemies_killed = 0
	resources_gained = 0
	
	resource_type.clear()
	units_type.clear()
	enemies_type.clear()
	
	load_resources_to_array(resources,"res://resources/resources/","tres")
	load_resources_to_array(buildings,"res://resources/buildings/","tres")
	load_resources_to_array(units,"res://resources/units/","tres")
	load_resources_to_array(enemies,"res://resources/enemies/","tres")
	
	resource_type.resize(len(resources))
	units_type.resize(len(units))
	enemies_type.resize(len(enemies))

	current_resources.resize(ResourceResource.RESOURCE.NORESOURCE)

	current_resources[ResourceResource.RESOURCE.WOOD] = 20
	current_resources[ResourceResource.RESOURCE.ROCK] = 4
	current_resources[ResourceResource.RESOURCE.IRON] = 0
	current_resources[ResourceResource.RESOURCE.GOLD] = 0
	current_resources[ResourceResource.RESOURCE.GEM] = 0
	current_resources[ResourceResource.RESOURCE.HELLIUM] = 0
	current_resources[ResourceResource.RESOURCE.OBSIDIANUM] = 0
	current_resources[ResourceResource.RESOURCE.COPIUM] = 0
	current_resources[ResourceResource.RESOURCE.AMONGIUM] = 0
	current_resources[ResourceResource.RESOURCE.FOOD] = 0
	
	set_all_resources(99) #TODO funkcja tylko do testów później usunąć
	
	DaylightManager.start_cycle()

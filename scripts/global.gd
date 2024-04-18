extends Node

const map_width = 1920
const map_height = 1080

var volume: float = 1.0

var unit_count = 0
var wave_count = 0




var resources:Array[ResourceResource] = []
var units:Array[UnitResource]= []
var buildings: Array[BuildingResource]= []


var current_resources:Array[int] = []


@export var work_range = 10
@export var work_speed = 1
@export var speed = 100
@export var damage:float = 5.0
@export var max_hp = 100
@export var cooldown = 2.0
@export var fight_range = 30




enum ENEMY {SLIME,WENDIGO,PEASANT,PRIEST,KNIGHT,HORSEMAN}
var enemies = {
	ENEMY.SLIME: {
		"name" : "Chłop", "sprite": preload("res://sprites/Units/Peasant.png"),
		"object": preload("res://object/unit.tscn"),
		"tool": preload("res://sprites/Items/NoItem.png"),
		"HP" : 10, "range" : 15, 
		"damage" : 1, "cooldown" : 1.0,
		"speed" : 50
	},
	ENEMY.WENDIGO: {
		"name" : "Kapłan", "sprite": preload("res://sprites/Units/Priest.png"),
		"object": preload("res://object/unit.tscn"),
		"tool": preload("res://sprites/Items/NoItem.png"),
		"HP" : 45, "range" : 30, 
		"damage" : 3, "cooldown" : 0.5,
		"speed" : 40
	},
	ENEMY.PEASANT: {
		"name" : "Chłop", "sprite": preload("res://sprites/Units/Peasant.png"),
		"object": preload("res://object/unit.tscn"),
		"tool": preload("res://sprites/Items/PitchFork.png"),
		"HP" : 15, "range" : 30, 
		"damage" : 1, "cooldown" : 1.0,
		"speed" : 75
	},
	ENEMY.PRIEST: {
		"name" : "Kapłan", "sprite": preload("res://sprites/Units/Priest.png"),
		"object": preload("res://object/unit.tscn"),
		"tool": preload("res://sprites/Items/Warhammer.png"),
		"HP" : 25, "range" : 50, 
		"damage" : 10, "cooldown" : 2.0,
		"speed" : 45
	},
	ENEMY.KNIGHT: {
		"name" : "Rycerz", "sprite": preload("res://sprites/Units/knight.png"),
		"object": preload("res://object/unit.tscn"),
		"tool": preload("res://sprites/Items/Sword.png"),
		"HP" : 45, "range" : 30, 
		"damage" : 10, "cooldown" : 1.5,
		"speed" : 50
	},
	ENEMY.HORSEMAN: {
		"name" : "Kawalerzysta", "sprite": preload("res://sprites/Units/Horseman.png"),
		"object": preload("res://object/unit.tscn"),
		"tool": preload("res://sprites/Items/spear.png"),
		"HP" : 55, "range" : 30, 
		"damage" : 8, "cooldown" : 2.0,
		"speed" : 100
	},
	
}

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
	load_resources_to_array(resources,"res://resources/resources/","tres")
	load_resources_to_array(buildings,"res://resources/buildings/","tres")
	load_resources_to_array(units,"res://resources/units/","tres")
	current_resources.resize(ResourceResource.RESOURCE.NORESOURCE)
	print(len(current_resources))
	current_resources[ResourceResource.RESOURCE.WOOD] = 10
	current_resources[ResourceResource.RESOURCE.ROCK] = 10
	current_resources[ResourceResource.RESOURCE.IRON] = 4
	current_resources[ResourceResource.RESOURCE.GOLD] = 4
	current_resources[ResourceResource.RESOURCE.GEM] = 2
	current_resources[ResourceResource.RESOURCE.HELLIUM] = 1
	current_resources[ResourceResource.RESOURCE.OBSIDIANUM] = 5
	current_resources[ResourceResource.RESOURCE.COPIUM] = 1
	current_resources[ResourceResource.RESOURCE.AMONGIUM] = 1
	current_resources[ResourceResource.RESOURCE.FOOD] = 10
	
	print(subtract_resources([ResourceStack.new(ResourceResource.RESOURCE.FOOD,10),ResourceStack.new(ResourceResource.RESOURCE.OBSIDIANUM,3)]))

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
	
		
	
	
func subtract_resources(resources: Array[ResourceStack]):
	for resource in resources:
		if current_resources[resource.type] < resource.count:
			return false
	for resource in resources:
		current_resources[resource.type] -= resource.count
	return true	
#
func get_resource_count(resource_type : ResourceResource) -> int:
	return current_resources[resource_type.type]

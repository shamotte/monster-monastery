extends Node

const map_width = 1920
const map_height = 1080

var volume: float = 1.0

var unit_count = 0
var wave_count = 0



var resources:Array[ResourceResource] = []
var units:Array[UnitResource]= []
var buildings: Array[BuildingResource]= []






var current_resources = {}








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
			#if file_name.ends_with(".remap"):
			#	file_name = file_name.replace(".remap","")
			#print(file_name)
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

	
	#for r in resources:
		#current_resources[r] = 0
	#Startign Resources
	#current_resources[RESOURCE.WOOD] = 10
	#current_resources[RESOURCE.ROCK] = 10
	#current_resources[RESOURCE.IRON] = 4
	#current_resources[RESOURCE.GOLD] = 4
	#current_resources[RESOURCE.GEM] = 2
	#current_resources[RESOURCE.HELLIUM] = 1
	#current_resources[RESOURCE.OBSIDIANUM] = 5
	#current_resources[RESOURCE.COPIUM] = 1
	#current_resources[RESOURCE.AMONGIUM] = 1
	#current_resources[RESOURCE.FOOD] = 10

#func _process(delta):
	#if Input.is_action_just_pressed("fullscreen"):
		#var get_mode = DisplayServer.window_get_mode()
		#if get_mode != DisplayServer.WINDOW_MODE_FULLSCREEN and get_mode != DisplayServer.WINDOW_MODE_MAXIMIZED:
			#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		#else:
			#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	#
#func add_resources(resource : RESOURCE, count : int):
	#if current_resources.has(resource):
		#current_resources[resource] += count
	#else:
		#current_resources[resource] = count
	#
#func subtract_resources(resource : RESOURCE, count : int) -> bool:
	#if current_resources.has(resource):
		#if current_resources[resource] >=count:
			#current_resources[resource] -= count
			#return true
		#else:
			#return false
	#else:
		#return false
#
#func get_resource_count(resource : RESOURCE) -> int:
	#if current_resources.has(resource):
		#return current_resources[resource]
	#else:
		#return 0

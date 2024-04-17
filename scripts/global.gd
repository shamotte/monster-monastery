extends Node

const map_width = 1920
const map_height = 1080

var volume: float = 1.0


var ITEM_OFFSET = 1000
enum RESOURCE {WOOD, ROCK, IRON, GOLD, GEM, HELLIUM, OBSIDIANUM , COPIUM, AMONGIUM,FOOD}
var resources = {
	RESOURCE.WOOD: {
		"name": "Wood", "sprite": preload("res://sprites/Resources/wood.png"), "type" : Priorities.ACTIONTYPES.GATHER
		,"time" : 2.0, "resource_point_texture": preload("res://sprites/Resources/tree.png")
	},
	RESOURCE.ROCK: {
		"name": "Rock", "sprite": preload("res://sprites/Resources/rockium.png"), "type" : Priorities.ACTIONTYPES.GATHER
		,"time" : 3.0, "resource_point_texture": preload("res://sprites/Resources/rock.png")	
	},
	RESOURCE.IRON: {
		"name": "Iron", "sprite": preload("res://sprites/Resources/crafted_iron.png"), "type" : Priorities.ACTIONTYPES.GATHER,
		"time" : 7.0, "resource_point_texture": preload("res://sprites/Resources/Iron.png")
	},
	RESOURCE.GOLD: {
		"name": "Gold", "sprite": preload("res://sprites/Resources/crafted_gold.png"), "type" : Priorities.ACTIONTYPES.GATHER
		,"time" : 10.0, "resource_point_texture": preload("res://sprites/Resources/gold.png")
	},
	RESOURCE.GEM: {
		"name": "Gem", "sprite": preload("res://sprites/Resources/green_gem.png"), "type" : Priorities.ACTIONTYPES.GATHER
		,"time" : 10.0, "resource_point_texture": preload("res://sprites/Resources/gem_stone.png")
	},
	RESOURCE.HELLIUM: {
		"name": "Helium", "sprite": preload("res://sprites/Resources/hellium.png"), "type" : Priorities.ACTIONTYPES.GATHER
		,"time" : 10.0, "resource_point_texture": null
	},
	RESOURCE.OBSIDIANUM: {
		"name": "Obsidianium", "sprite": preload("res://sprites/Resources/obsidianium.png"), "type" : Priorities.ACTIONTYPES.GATHER
		,"time" : 10.0, "resource_point_texture": preload("res://sprites/Resources/Obsidianium_rock.png")
	},
	RESOURCE.COPIUM: {
		"name": "Copium", "sprite": preload("res://sprites/Resources/Copium1.png"), "type" : Priorities.ACTIONTYPES.GATHER
		,"time" : 10.0, "resource_point_texture": null
	},
	RESOURCE.AMONGIUM: {
		"name": "Amongium", "sprite": preload("res://sprites/Resources/Amongium.png"), "type" : Priorities.ACTIONTYPES.GATHER
		,"time" : 10.0, "resource_point_texture": null
	},
	RESOURCE.FOOD: {
		"name": "Food", "sprite": preload("res://sprites/Resources/yummy.png"), "type" : Priorities.ACTIONTYPES.GATHER
		,"time" : 2.0, "resource_point_texture": null
	}
}



var current_resources = {}




enum RECIPES {COPIUM,AMONGIUM1,OBSIDIANUM,HELLIUM, FOOD1, FOOD2,AMONGIUM2}
var recipes = {
	RECIPES.COPIUM : {
		"work" : 10.0, "ingredients" : [[RESOURCE.GEM,10], [RESOURCE.ROCK,10]],
		"results": [[RESOURCE.COPIUM,1]]
	},
	
	RECIPES.AMONGIUM1 : {
		"work" : 10.0, "ingredients" : [[RESOURCE.COPIUM,5], [RESOURCE.GEM,5]],
		"results": [[RESOURCE.AMONGIUM, 1]]
	},
	RECIPES.OBSIDIANUM : {
		"work" : 5.0, "ingredients" : [[RESOURCE.ROCK,3], [RESOURCE.GOLD, 3]],
		"results": [[RESOURCE.OBSIDIANUM,3]]
	},
	RECIPES.HELLIUM : {
		"work" : 5.0, "ingredients" : [[RESOURCE.OBSIDIANUM, 2], [RESOURCE.AMONGIUM, 2]],
		"results": [[RESOURCE.HELLIUM,1]]
	},
	RECIPES.FOOD1 : {
		"work" : 15.0, "ingredients" : [[RESOURCE.WOOD,3]],
		"results": [[RESOURCE.FOOD,1]]
	},
	RECIPES.FOOD2 : {
		"work" : 5.0, "ingredients" : [[RESOURCE.WOOD,2]],
		"results": [[RESOURCE.FOOD,3]]
	},
	RECIPES.AMONGIUM2 : {
		"work" : 5.0, "ingredients" : [[RESOURCE.COPIUM,1],[RESOURCE.GEM,1]],
		"results": [[RESOURCE.AMONGIUM,2]]
	}
}

enum BUILDINGS { PORTAL,TOWER,LAVALAKE,FORGE,TENTACLE,TENTACLESFIELD,MONASTERY}
var buildings = {
	BUILDINGS.PORTAL: {
		"name": "Portal","sprite": preload("res://sprites/Buildings/DonutPortal.png"),
		"resource_type": [RESOURCE.GEM,RESOURCE.OBSIDIANUM], "resource_cost": [1,3],
		"object": preload("res://object/tower.tscn"),
		"recipe" : RECIPES.COPIUM
	},
	BUILDINGS.TOWER: {
		"name": "Tower","sprite": preload("res://sprites/Buildings/tower.png"),
		"resource_type": [RESOURCE.HELLIUM,RESOURCE.OBSIDIANUM], "resource_cost": [2,5],
		"object": preload("res://object/tower.tscn"),
		"recipe" :RECIPES.AMONGIUM1
	},
	BUILDINGS.LAVALAKE: {
		"name": "Lava Lake","sprite": preload("res://sprites/Buildings/LavaLake.png"),
		"resource_type": [RESOURCE.OBSIDIANUM,RESOURCE.ROCK], "resource_cost": [3,10],
		"object": preload("res://object/tower.tscn"),
		"recipe" : RECIPES.OBSIDIANUM
	},
	BUILDINGS.FORGE: {
		"name": "Forge","sprite": preload("res://sprites/Buildings/Forge.png"),
		"resource_type": [RESOURCE.IRON,RESOURCE.GOLD], "resource_cost": [15,15],
		"object": preload("res://object/tower.tscn"),
		"recipe" : RECIPES.HELLIUM
	},
	BUILDINGS.TENTACLE: {
		"name": "Tentacle","sprite": preload("res://sprites/Buildings/Tentacle.png"),
		"resource_type": [RESOURCE.WOOD,RESOURCE.ROCK], "resource_cost": [5,5],
		"object": preload("res://object/tower.tscn"),
		"recipe" : RECIPES.FOOD1
	},
	BUILDINGS.TENTACLESFIELD: {
		"name": "Tentacles","sprite": preload("res://sprites/Buildings/Tentacles.png"),
		"resource_type": [RESOURCE.FOOD,RESOURCE.GOLD], "resource_cost": [30,3],
		"object": preload("res://object/tower.tscn"),
		"recipe" : RECIPES.FOOD2
	},
	BUILDINGS.MONASTERY: {
		"name": "Tentacles","sprite": preload("res://sprites/Buildings/Monastery.png"),
		"resource_type": [RESOURCE.AMONGIUM,RESOURCE.OBSIDIANUM], "resource_cost": [1,20],
		"object": preload("res://object/tower.tscn"),
		"recipe" : RECIPES.AMONGIUM2
	},
}

@export var work_range = 10
@export var work_speed = 1
@export var speed = 100
@export var damage:float = 5.0
@export var max_hp = 100
@export var cooldown = 2.0
@export var fight_range = 30

enum UNIT {SLIME,REDSLIMES,SHROOM,CULTIST,IMP,WENDIGO,CEMON,PYTHONUS,LORD}
var units = {
	UNIT.REDSLIMES: {
		"name" : "Slime", "sprite": preload("res://sprites/Units/slime_red.png"),
		"toolSprite" : null,
		"resource_type": [RESOURCE.HELLIUM], "resource_cost": [4],
		"object": preload("res://object/unit.tscn"),
		"work_range" : 10, "work_speed" : 0.4,
		"speed" : 300, "HP" : 25, "damage" : 1,
		"cooldown" : 0.1, "fight_range" : 30
	},
	UNIT.SLIME: {
		"name" : "Slime", "sprite": preload("res://sprites/Units/slimebehindtheslaughter.png"),
		"toolSprite" : null,
		"resource_type": [RESOURCE.WOOD], "resource_cost": [4],
		"object": preload("res://object/unit.tscn"),
		"work_range" : 10, "work_speed" : 0.2,
		"speed" : 30, "HP" : 25, "damage" : 3,
		"cooldown" : 1.0, "fight_range" : 30
	},
	UNIT.SHROOM: {
		"name" : "Shroom", "sprite": preload("res://sprites/Units/shroom.png"),
		"toolSprite" : null,
		"resource_type": [RESOURCE.FOOD], "resource_cost": [4],
		"object": preload("res://object/unit.tscn"),
		"work_range" : 10, "work_speed" : 0.3,
		"speed" : 40, "HP" : 25, "damage" : 1,
		"cooldown" : 0.2, "fight_range" : 10
	},
	UNIT.CULTIST: {
		"name" : "Cultist", "sprite": preload("res://sprites/Units/Cultist.png"),
		"toolSprite" : preload("res://sprites/Items/Eye_Staff.png"),
		"resource_type": [RESOURCE.FOOD,RESOURCE.GEM], "resource_cost": [4,1],
		"object": preload("res://object/unit.tscn"),
		"work_range" : 50, "work_speed" : 0.5,
		"speed" : 80, "HP" : 25, "damage" : 10,
		"cooldown" : 2.0, "fight_range" : 90
	},
	UNIT.IMP: {
		"name" : "Imp", "sprite": preload("res://sprites/Units/imp.png"),
		"toolSprite" : preload("res://sprites/Items/PitchFork.png"),
		"resource_type": [RESOURCE.WOOD,RESOURCE.ROCK], "resource_cost": [4,4],
		"object": preload("res://object/unit.tscn"),
		"work_range" : 10, "work_speed" : 1,
		"speed" : 120, "HP" : 15, "damage" : 1,
		"cooldown" : 0.5, "fight_range" : 40
	},
	UNIT.WENDIGO: {
		"name" : "Wendigo", "sprite": preload("res://sprites/Units/wendigo.png"),
		"toolSprite" : null,
		"resource_type": [RESOURCE.WOOD], "resource_cost": [20],
		"object": preload("res://object/unit.tscn"),
		"work_range" : 20, "work_speed" : 1.5,
		"speed" : 70, "HP" : 35, "damage" : 7,
		"cooldown" : 2.0, "fight_range" : 40
	},
	UNIT.CEMON: {
		"name" : "Cemon", "sprite": preload("res://sprites/Units/Cemon.png"),
		"toolSprite" : null,
		"resource_type": [RESOURCE.FOOD,RESOURCE.COPIUM], "resource_cost": [10,1],
		"object": preload("res://object/unit.tscn"),
		"work_range" : 10, "work_speed" : 0.8,
		"speed" : 50, "HP" : 60, "damage" : 6,
		"cooldown" : 1, "fight_range" : 40
	},
	UNIT.PYTHONUS: {
		"name" : "Pythonus", "sprite": preload("res://sprites/Units/Pythonomium.png"),
		"toolSprite" : null,
		"resource_type": [RESOURCE.IRON,RESOURCE.GOLD], "resource_cost": [4,4],
		"object": preload("res://object/unit.tscn"),
		"work_range" : 15, "work_speed" : 2,
		"speed" : 100, "HP" : 20, "damage" : 8,
		"cooldown" : 1.5, "fight_range" : 40
	},
	UNIT.LORD: {
		"name" : "Baron", "sprite": preload("res://sprites/Units/DemonLord.png"),
		"toolSprite" : preload("res://sprites/Items/demon_sword.png"),
		"resource_type": [RESOURCE.AMONGIUM,RESOURCE.OBSIDIANUM], "resource_cost": [1,5],
		"object": preload("res://object/unit.tscn"),
		"work_range" : 30, "work_speed" : 0.2,
		"speed" : 66, "HP" : 66, "damage" : 16,
		"cooldown" : 2.5, "fight_range" : 40
	},
}

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

enum PRIORIRITY {WOOD,ROCK,IRON,FOOD,GOLD,CRAFT,FIGHT}
var priorieties = {
	PRIORIRITY.WOOD: {
		"name" : "Wood", "sprite": preload("res://sprites/Resources/wood.png")
		},
	PRIORIRITY.ROCK: {
		"name" : "Rock", "sprite": preload("res://sprites/Resources/green_gem.png")
		},
	PRIORIRITY.IRON: {
		"name" : "Iron", "sprite": preload("res://sprites/Resources/Copium1.png")
		},
	PRIORIRITY.FOOD: {
		"name" : "Food", "sprite": preload("res://sprites/Resources/Amongium.png")
		},
	PRIORIRITY.GOLD: {
		"name" : "Gold", "sprite": preload("res://sprites/Resources/obsidianium.png")
		},
	PRIORIRITY.CRAFT: {
		"name" : "Craft", "sprite": preload("res://sprites/UI/axe32.png")
		},
	PRIORIRITY.FIGHT: {
		"name" : "Fight", "sprite": preload("res://sprites/UI/axe32.png")
		},
	}


func _ready():
	for r in resources:
		current_resources[r] = 0
	#Startign Resources
	current_resources[RESOURCE.WOOD] = 10
	current_resources[RESOURCE.ROCK] = 10
	current_resources[RESOURCE.IRON] = 4
	current_resources[RESOURCE.GOLD] = 4
	current_resources[RESOURCE.GEM] = 2
	current_resources[RESOURCE.HELLIUM] = 1
	current_resources[RESOURCE.OBSIDIANUM] = 5
	current_resources[RESOURCE.COPIUM] = 1
	current_resources[RESOURCE.AMONGIUM] = 1
	current_resources[RESOURCE.FOOD] = 10

func _process(delta):
	if Input.is_action_just_pressed("fullscreen"):
		var get_mode = DisplayServer.window_get_mode()
		if get_mode != DisplayServer.WINDOW_MODE_FULLSCREEN and get_mode != DisplayServer.WINDOW_MODE_MAXIMIZED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
func add_resources(resource : RESOURCE, count : int):
	if current_resources.has(resource):
		current_resources[resource] += count
	else:
		current_resources[resource] = count
	
func subtract_resources(resource : RESOURCE, count : int) -> bool:
	if current_resources.has(resource):
		if current_resources[resource] >=count:
			current_resources[resource] -= count
			return true
		else:
			return false
	else:
		return false

func get_resource_count(resource : RESOURCE) -> int:
	if current_resources.has(resource):
		return current_resources[resource]
	else:
		return 0

extends Resource
class_name ResourceResource

enum RESOURCE {WOOD, ROCK, IRON, GOLD, GEM, HELLIUM, OBSIDIANUM , COPIUM, AMONGIUM,FOOD}
@export_group("Resource")
@export var name:String
@export var sprite:CompressedTexture2D
@export var type:RESOURCE

@export_group("Resource Point")
@export var action_type: Priorities.ACTIONTYPES
@export var time:float
@export var resource_point_txture: CompressedTexture2D

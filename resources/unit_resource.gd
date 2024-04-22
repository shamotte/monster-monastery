extends Resource
class_name UnitResource

enum UNIT {SLIME,REDSLIMES,SHROOM,CULTIST,IMP,WENDIGO,CEMON,PYTHONUS,LORD,DEMON}

@export_group("Basic")
@export var name:String
@export var sprite: CompressedTexture2D
@export var item: CompressedTexture2D
@export var extra: Script
@export var resource_cost: Array[ResourceStack]
@export var speed: float
@export var type:UNIT


@export_group("Work")
@export var work_range:float
@export var work_speed : float


@export_group("Fight")
@export var cooldown:float
@export var hp:float
@export var damage:float
@export var fight_range:float

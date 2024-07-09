extends Resource
class_name EnemyResource

enum ENEMY {PEASANT,PRIEST,ARCHER,KNIGHT,HORSEMAN}

@export_group("Basic")
@export var name:String
@export var sprite: CompressedTexture2D
@export var item: CompressedTexture2D
@export var extra: Script
@export var speed: float
@export var strength: float 
@export var type:ENEMY


@export_group("Fight")
@export var cooldown:float
@export var hp:float
@export var damage:float
@export var fight_range:float
@export var ability: Ability

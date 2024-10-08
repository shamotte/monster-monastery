extends Resource
class_name UnitResource

#SUMMONED should be always on back side because summary don't include last position
enum UNIT {SLIME,IMP,SHROOM,TREANT,WENDIGO,LEMON,DEMON,CEMON,CULTIST,PYTHONUS,GOLEM,REDSLIMES,LORD,WALLOFEYES,MIRRORIUM,SUMMONED}

@export_group("Basic")
@export var name:String
@export_multiline var description:String
@export var extra: Script
@export var resource_cost: Array[ResourceStack]
@export var speed: float
@export var type:UNIT

@export_group("Visual")
@export var sprite: CompressedTexture2D
@export var item: CompressedTexture2D
@export var scale : float = 1
@export var color : Color = Color.WHITE
@export var play_dead_anim : bool = true


@export_group("Work")
@export var work_range:float
@export var work_speed : float


@export_group("Fight")
@export var cooldown:float
@export var hp:float
@export var damage:float
@export var fight_range:float
@export var abilities: Array[Ability]

extends Resource
class_name BuildingResource

enum BUILDINGS { PORTAL,TOWER,LAVALAKE,FORGE,TENTACLE,TENTACLESFIELD,MONASTERY}

@export var name:String
@export var type:BUILDINGS
@export var sprite: CompressedTexture2D
@export var resource_cost: Array[ResourceStack]
@export var recipes: Array[RecipeResource]

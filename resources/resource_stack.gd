extends Resource
class_name ResourceStack
@export var type : ResourceResource.RESOURCE
@export var count: int

func _init(_type = ResourceResource.RESOURCE.WOOD, _count = 0):
	type = _type
	count = _count

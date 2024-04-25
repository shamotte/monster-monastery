extends Resource
class_name ResourceStack
@export var type : ResourceResource.RESOURCE
@export var count: int

func _init(_type = ResourceResource.RESOURCE.NORESOURCE, _count = 0):
	if type != null:
		if type is ResourceResource.RESOURCE:
			type = _type
			count = _count
	

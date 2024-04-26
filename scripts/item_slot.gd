extends Control

@export var stack: ResourceStack

func _ready():
	$Sprite.texture = Global.resources[stack.type].sprite
	$Count.text = str(stack.count)

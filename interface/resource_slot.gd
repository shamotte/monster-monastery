extends Control

func set_image(image : CompressedTexture2D):
	$Sprite.texture = image

func set_amount(amount : int):
	$Count.text = str(amount)

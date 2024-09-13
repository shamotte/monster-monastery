extends Control


func set_number(value : int):
	$Label.text = str(value)
	
func set_image(image : CompressedTexture2D):
	$TextureRect.texture = image

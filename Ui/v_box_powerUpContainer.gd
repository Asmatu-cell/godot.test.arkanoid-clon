class_name vBoxContainerPowerUp extends Panel


func initialize (texture:CompressedTexture2D, name:String):
	$TextureRect.texture = texture
	$Label.text = name
	pass

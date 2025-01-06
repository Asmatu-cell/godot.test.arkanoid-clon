class_name vBoxContainerPowerUp extends Panel


func initialize (texture:CompressedTexture2D, powerUpName:String):
	$TextureRect.texture = texture
	$Label.text = powerUpName
	pass

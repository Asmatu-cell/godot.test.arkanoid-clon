extends StaticBody2D

signal out


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# var pelotasActuales = get_tree().current_scene.find_children("Pelota*", "", false, false)
	# if pelotasActuales.size() == 0:
	#	print("HAS PERDIDO")	
	pass

func _on_out() -> void:	
	var pelotasActuales = get_tree().current_scene.find_children("Pelota*", "", false, false)
	if pelotasActuales.size() == 0 || pelotasActuales.size() == 1:
		GameController.life_changed(-1)
		GameController.clean_powerups()
		GameController.reset_powers()
		GameController.create_new_ball()
	pass

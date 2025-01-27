extends StaticBody2D

signal out


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_out() -> void:	
	var pelotasActuales = get_tree().current_scene.find_children("Pelota*", "", false, false)
	if pelotasActuales.size() == 0 || pelotasActuales.size() == 1:
		GameController.destroy_ball()
	pass

class_name gameController
extends Node

@export var life = 3
var label:Label
var tablaActual

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	var current_scene =	get_tree().current_scene
	tablaActual = current_scene.find_children("Tabla", "", false, false)[0]
	label = current_scene.find_children("Label", "", false, false)[0]	
	#label.text = label.text.format({"life": life})
	label.text = "Vidas: " + str(life)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	pass
	
func life_changed(qty:int) -> void:	
	life += qty;
	label.text = "Vidas: " + str(life)
	
	if life <= 0:
		label.text ="HAS PERDIDO"
	else:
		tablaActual.emit_signal("new_ball");
		
	print(life)
	pass

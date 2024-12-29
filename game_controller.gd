class_name gameController
extends Node

@export var life = 3
@export var points = 0
var labelVidas:Label
var labelPuntos:Label
var modoDisparo:bool = false
var tablaActual

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	var current_scene =	get_tree().current_scene
	tablaActual = current_scene.find_children("Tabla", "", false, false)[0]
	labelVidas = current_scene.find_children("Vidas", "", false, false)[0]	
	labelPuntos = current_scene.find_children("Puntos", "", false, false)[0]	
	#label.text = label.text.format({"life": life})
	labelVidas.text = "Vidas: " + str(life)
	labelPuntos.text = str(points)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var disparado = Input.is_action_just_pressed("disparo")
	
	if disparado && modoDisparo:
		disparar()
	pass

func reset_powers():
	modoDisparo = false
	tablaActual.find_child("Shoters Container").visible = false
	tablaActual.emit_signal("set_contact_mode", false)
		
func points_add(points_to_add:int) -> void:	
	points += points_to_add
	labelPuntos.text = str(points)

func life_changed(qty:int) -> void:	
	life += qty;
	labelVidas.text = "Vidas: " + str(life)
	
	if life <= 0:
		labelVidas.text = "HAS PERDIDO"
	pass

func create_new_ball() -> void:
	tablaActual.emit_signal("new_ball")

func disparar() -> void:
	print("hemos disparado")
	tablaActual.emit_signal("disparar")

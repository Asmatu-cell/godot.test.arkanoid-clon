class_name gameController
extends Node

const TABLA = preload("res://Scenes/tabla/tabla.tscn")

@export var life = 1
@export var points = 0
var labelVidas:Label
var labelPuntos:Label
var modoDisparo:bool = false
var tablaActual

var level = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	#level_init()	
	pass

func get_current_level() -> int:
	return level

func level_init():
	var current_scene =	get_tree().current_scene
	tablaActual = TABLA.instantiate()
	tablaActual.name = "Tabla"
	current_scene.add_child(tablaActual)	
	tablaActual.call("createNewBall")
	if current_scene.name != "Main Menu":
		init_ui()		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var disparado = Input.is_action_just_pressed("disparo")
	
	if disparado && modoDisparo:
		disparar()
	pass

func game_over():
	labelVidas.text = "HAS PERDIDO"
	tablaActual.emit_signal("explotar")
	await get_tree().create_timer(3).timeout	
	get_tree().change_scene_to_file("res://Scenes/UI/game_over_scene.tscn")

func destroy_ball():
	life_changed(-1)
	clean_powerups()
	reset_powers()
	if life <= 0:
		game_over()
	else:
		create_new_ball()
	
func reset_powers():
	modoDisparo = false
	tablaActual.find_child("Shoters Container").visible = false
	tablaActual.emit_signal("set_contact_mode", false)

func init_ui():
	var current_scene =	get_tree().current_scene	
	labelVidas = current_scene.find_children("Vidas", "", true, false)[0]	
	labelPuntos = current_scene.find_children("Puntos", "", true, false)[0]		
	labelVidas.text = "Vidas: " + str(life)
	labelPuntos.text = str(points)

func clean_powerups():
	for power_up in get_tree().get_nodes_in_group("power_ups"):
		if power_up:
			power_up.queue_free()
		
func points_add(points_to_add:int) -> void:	
	points += points_to_add
	labelPuntos.text = str(points)

func life_changed(qty:int) -> void:	
	life += qty;
	labelVidas.text = "Vidas: " + str(life)
	
	pass

func create_new_ball() -> void:
	tablaActual.emit_signal("new_ball")

func disparar() -> void:
	tablaActual.emit_signal("disparar")

func check_remaining_blocks_for_next_level():	
	var remaining_blocks = get_tree().get_nodes_in_group("bloques_destruibles")	
	if (remaining_blocks.size() < 1):		
		GameController.change_scene_to_next()
	
func change_scene_to_next() -> void:	
	#get_tree().change_scene_to_packed()
	points_add(500)
	level += 1
	get_tree().change_scene_to_file("res://Scenes/UI/new_level_screen.tscn")
	pass

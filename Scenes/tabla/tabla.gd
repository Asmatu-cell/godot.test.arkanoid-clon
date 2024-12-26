class_name Tabla
extends CharacterBody2D

const ESCENA_PELOTA = preload("res://Scenes/pelota/pelota.tscn")
@export var SPEED = 500.0
const PUSH_FORCE = 1000
const INITIAL_POSITION_X = 548
const INITIAL_POSITION_Y = 845

@export var base_width_scale = 1.0
@export var base_height_scale = 1.0
@export var transition_speed = 2.0
var new_width_scale = 1.0
var transition_elapsed_time = 0.0
signal new_ball(qty)

func _physics_process(delta):
	if new_width_scale != scale.x:		
		transition_elapsed_time += delta / transition_speed		
		scale.x = lerp(scale.x, new_width_scale, transition_elapsed_time)
		if (new_width_scale > base_width_scale && scale.x > new_width_scale) || (new_width_scale < base_width_scale && scale.x < new_width_scale):
			scale.x = new_width_scale
	# Obtener la dirección del input horizontal
	var direction = Input.get_axis("lpad", "rpad")
	var disparado = Input.is_action_just_pressed("disparo")
	
	if disparado:
		disparar()
		print("hemos disparado")
	
	# Manejar movimiento horizontal y desaceleración
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta * 8)
	
	# Mover el personaje usando la velocidad
	move_and_slide()

func disparar():
	#var pelotaActual:pelota = get_tree().current_scene.find_child("Pelota")
	var pelotasActuales = get_tree().current_scene.find_children("Pelota*", "", false, false)
	var pelotasActualesSize = pelotasActuales.size()
	if  pelotasActualesSize < 12:
		for i in pelotasActuales.size():
			duplicarPelota(pelotasActuales[i])
			pelotasActualesSize += 1
			if  pelotasActualesSize < 12:
				pass	

func duplicarPelota(pelotaActual:pelota):	
	var pelotaObject:pelota =  ESCENA_PELOTA.instantiate()
	pelotaObject.position = pelotaActual.position	
	get_tree().current_scene.add_child(pelotaObject)	
	pelotaObject.velocity = pelotaActual.velocity
	
	var n = randf()
	var n2 = 1 + n	
	pelotaObject.velocity.x = pelotaObject.velocity.x * - n
	pelotaObject.velocity.y = pelotaObject.velocity.y * - n2
	pelotaObject.name = "Pelota"

func createNewBall():
	var pelotaObject:pelota =  ESCENA_PELOTA.instantiate()
	pelotaObject.position = position
	pelotaObject.position.y -= 10
	get_tree().current_scene.add_child(pelotaObject)

func _on_new_ball() -> void:
	await explosion()
	await reset_positions()
	await createNewBall()
	pass

func reset_positions():	
	position.x = INITIAL_POSITION_X
	position.y = INITIAL_POSITION_Y
	new_width_scale = base_width_scale
	scale.x = base_width_scale
	scale.y = base_height_scale
	
	$AudioReset.play()
	await get_tree().create_timer(0.5).timeout
	pass

func explosion():
	$AudioExplosion.play()
	await get_tree().create_timer(1).timeout
	pass

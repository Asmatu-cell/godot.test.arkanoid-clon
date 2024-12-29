class_name Tabla
extends CharacterBody2D

const ESCENA_PELOTA = preload("res://Scenes/pelota/pelota.tscn")
const LASER_BULLET = preload("res://Scenes/tabla/laser_bullet.tscn")

@export var SPEED = 600.0
const PUSH_FORCE = 1000
const INITIAL_POSITION_X = 417
const INITIAL_POSITION_Y = 880

@export var base_width_scale = 1.0
@export var base_height_scale = 1.0
@export var transition_speed = 2.0
var new_width_scale = 1.0
var transition_elapsed_time = 0.0
@export var IS_STICKY:bool = false
signal new_ball(qty)
signal set_contact_mode()
signal disparar()

var sticked_balls: = []
var already_shot = false

func _physics_process(delta):
	if Input.is_action_just_pressed("disparo") && sticked_balls.size() > 0:
		for ball in sticked_balls:
			ball.emit_signal("ball_end_contact")
			pass
		sticked_balls = []
		
	# Obtener la dirección del input horizontal
	var direction = Input.get_axis("lpad", "rpad")
	# Manejar movimiento horizontal y desaceleración
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta * 8)
	
	if new_width_scale != scale.x:
		transition_elapsed_time += delta / transition_speed		
		scale.x = lerp(scale.x, new_width_scale, transition_elapsed_time)
		if (new_width_scale > base_width_scale && scale.x > new_width_scale) || (new_width_scale < base_width_scale && scale.x < new_width_scale):
			scale.x = new_width_scale

	# Mover el personaje usando la velocidad
	var previous_position = global_position  # Guarda la posición actual antes de mover
	move_and_slide()
	var movement_delta = global_position - previous_position  # Calcula cuánto se ha movido

	# Mover las bolas pegadas junto a la tabla
	for ball in sticked_balls:
		ball.global_position += movement_delta

func _on_new_ball() -> void:
	await explosion()
	await reset_positions()
	await createNewBall()
	pass

func createNewBall():
	var pelotaObject:pelota =  ESCENA_PELOTA.instantiate()
	pelotaObject.position = position
	pelotaObject.position.y -= 30
	get_tree().current_scene.add_child(pelotaObject)
	pelotaObject.velocity = pelotaObject.velocity.rotated(PI)


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

func is_sticky() -> bool:
	return IS_STICKY
	
func add_sticked_element(pelota_object: pelota):
	sticked_balls.append(pelota_object)
	pass
func _on_set_contact_mode(active: bool) -> void:
	IS_STICKY = active

func _on_disparar() -> void:
	if already_shot == false:
		already_shot = true
		var proyectilR = LASER_BULLET.instantiate()  # Instancia el proyectil
		var proyectilL = LASER_BULLET.instantiate()  # Instancia el proyectil
		proyectilR.position = $"Shoters Container/LaserShooter".global_position  # Establece la posición de origen del proyectil (en el objeto que lo lanza)
		proyectilL.position = $"Shoters Container/LaserShooter2".global_position  # Establece la posición de origen del proyectil (en el objeto que lo lanza)		
		$"Shoters Container/LaserShooter".add_child(proyectilR)  # Añade el proyectil a la escena
		$"Shoters Container/LaserShooter2".add_child(proyectilL)  # Añade el proyectil a la escena
		# Conecta la señal de impacto para reaccionar cuando el proyectil colisione	
		proyectilL.connect("hit", Callable(self, "_on_proyectil_hit"))		
		proyectilR.connect("hit", Callable(self, "_on_proyectil_hit"))		
	pass
	
func _on_proyectil_hit(body):
	print("El proyectil ha impactado con: ", body)  # Muestra qué objeto fue impactado.
	already_shot = false
	if body.has_signal("hit"):
		body.emit_signal("hit")

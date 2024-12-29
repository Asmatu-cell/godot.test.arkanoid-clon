class_name pelota
extends CharacterBody2D

@export var INITIAL_SPEED = 450.0  # Velocidad inicial
@export var SPEED_INCREMENT = 2.0  # Incremento por golpe
@export var MAX_SPEED = 900.0  # Velocidad máxima permitida
@export var CURRENT_SPEED = 0

signal ball_transform
signal ball_end_contact

var DESTROYER_MODE = false
var ON_CONTACT = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready():	
	$BallRedBig.modulate = Color(1, 1, 1, 0)   # Asegurar que el rojo empieza invisible
	#velocity = Vector2(INITIAL_SPEED, 0).rotated(1)
	velocity = Vector2(INITIAL_SPEED, 0).rotated(PI / 4)

func _process(delta: float) -> void:
	if ON_CONTACT == false:
		pass
		$BallBlueSmall.rotate(round(velocity.y * PI / delta))

func _physics_process(delta: float) -> void:
	if ON_CONTACT == false:
		var collision = move_and_collide(velocity * delta)
		if collision:
			rebotar(collision)
			golpear(collision)

func golpear(collision: KinematicCollision2D):
	var collider = collision.get_collider()
	if collider.has_signal("hit"):
		collider.emit_signal("hit", DESTROYER_MODE)
	if collider.has_signal("out"):
		queue_free()
		collider.emit_signal("out")

func rebotar(collision: KinematicCollision2D):
	if DESTROYER_MODE && collision.get_collider().has_signal("hit"):
		return
	
	# Ajustar la dirección tras el rebote
	velocity = velocity.bounce(collision.get_normal())
	
		# Calcular el ángulo de la nueva velocidad
	var angle = velocity.angle()
	# Definir el ángulo mínimo en radianes (por ejemplo, 15 grados = 0.261799 radianes)
	var min_angle = deg_to_rad(15)

	# Si el ángulo de la velocidad es menor que el ángulo mínimo, ajustamos la dirección
	if abs(angle) < min_angle:
		velocity = velocity.rotated(min_angle * sign(angle)) 

	# Incrementar la velocidad tras el rebote
	var new_speed = velocity.length() + SPEED_INCREMENT
	if new_speed > MAX_SPEED:
		new_speed = MAX_SPEED  # Limitar a velocidad máxima

	CURRENT_SPEED = new_speed
	velocity = velocity.normalized() * new_speed
	
	if collision.get_collider().has_method("is_sticky") && collision.get_collider().call("is_sticky"):
		ON_CONTACT = true
		collision.get_collider().call("add_sticked_element", self)		
		return
	
	GameController.points_add(1)
	$Rebote.play()

func _on_ball_transform() -> void:
	DESTROYER_MODE = true
	$BallBlueSmall.modulate = Color(1, 1, 1, 1)  # Asegurar que el azul empieza visible
	$BallRedBig.modulate = Color(1, 1, 1, 0)   # Asegurar que el rojo empieza invisible

# Crear una interpolación asincrónica para el cambio
	var timer = 0.0
	while timer < 1.5:
		timer += get_process_delta_time()
		var t = timer / 1.5
		$BallBlueSmall.modulate.a = 1.0 - t  # Desvanece BallGrey
		$BallBlueSmall.scale.x = 0.5 + 1 * t
		$BallBlueSmall.scale.y = 0.5 + 1 * t
		$BallRedBig.modulate.a = t         # Hace aparecer BallRed
		$CollisionShape2D.scale.x = 1.5 + 0.55 * t
		$CollisionShape2D.scale.y = 1.5 + 0.55 * t
		await get_tree().process_frame
	
	print("Transición completada")	
	await get_tree().process_frame
		
	await _return_ball_to_normal(2.5)
	pass # Replace with function body.

# Función asincrónica para ocultar BallGreyBig tras un retraso
func _return_ball_to_normal(delay_seconds: float = 0) -> void:
	await get_tree().create_timer(delay_seconds).timeout
		
	$CollisionShape2D.scale.x = 1
	$CollisionShape2D.scale.y = 1
	DESTROYER_MODE = false
	
	var timer = 0.0
	while timer < 1:
		timer += get_process_delta_time() * 2
		var t = timer
		$BallRedBig.modulate.a = 1.0 - t
		$BallBlueSmall.modulate.a = t
		$BallBlueSmall.scale.x = 1.5 - (1 * t)
		$BallBlueSmall.scale.y = 1.5 - (1 * t)
		await get_tree().process_frame
	#endwhile


func _on_ball_end_contact() -> void:
	ON_CONTACT = false
	pass # Replace with function body.

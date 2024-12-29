class_name pelota
extends CharacterBody2D

@export var SPEED = 350.0
@export var ACCELERATION_VALUE_STEP = 0.01
@export var MAX_SPEED_BOOST = 3

signal ball_transform
signal ball_end_contact

var acceleration = 1
var DESTROYER_MODE = false
var ON_CONTACT = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready():
	$BallRedBig.modulate = Color(1, 1, 1, 0)   # Asegurar que el rojo empieza invisible
	velocity = Vector2(SPEED, 0).rotated(1)	

func _process(delta: float) -> void:
	if ON_CONTACT == false:
		$BallBlueSmall.rotate(round(acceleration / delta))

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
	
	
	velocity = velocity.bounce(collision.get_normal())	
	if acceleration < MAX_SPEED_BOOST:
		velocity /= acceleration
		acceleration += ACCELERATION_VALUE_STEP
		velocity *= acceleration
	
	if collision.get_collider().has_method("is_sticky") && collision.get_collider().call("is_sticky"):
		ON_CONTACT = true
		collision.get_collider().call("add_sticked_element", self)		
		return
	
	$Rebote.play()
	#print("Acceleration of the ball is ", acceleration, velocity)

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

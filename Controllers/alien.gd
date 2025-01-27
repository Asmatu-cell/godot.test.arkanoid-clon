class_name Alien
extends CharacterBody2D


# Velocidad del alien
signal hit
@export var hit_points = 1
@export var speed = 10
@export var moving_time = 6
@export var thinking_time = 2

var deceleration = 4.0

# Ángulo del zig-zag (en grados)
var zigzag_angle = 25  # El ángulo de zig-zag
var changing_direction = false
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	#position =  Vector2(50, 50)
	velocity = Vector2(randi_range(-speed, speed), speed * 2)	
	randomize()
	moving_time += randf_range(-1.5,1.5)
	thinking_time += randf_range(-0.5,0.5)
	$Timer.wait_time = moving_time / 2
	$Timer.start()
	pass

func _physics_process(delta):
	if changing_direction == true:
		velocity *= (1 - deceleration / 5.0 * delta)  # Multiplicamos para reducir la velocidad		
		# Si la velocidad es suficientemente pequeña, detener el movimiento
		if velocity.length() < 0.1:
			velocity = Vector2.ZERO  # Detenerse completamente

	var collision = move_and_collide(velocity * delta)	
	if collision:
		# Rebota dependiendo del ángulo de colisión
		velocity = velocity.bounce(collision.get_normal())
		
	pass

func change_direction():
	changing_direction = true
	print("changing direction")
	$Timer.set_paused(true)
	await get_tree().create_timer(thinking_time).timeout
	$Timer.set_paused(false)
	changing_direction = false	
	velocity = Vector2(speed, speed)	
	randomize()
	var rangedeg = deg_to_rad(randf_range(-3,3))
	var rotation_angle = zigzag_angle * rangedeg
	velocity = velocity.rotated(rotation_angle)


func _destroy():
	print("alien destroyed")
	#queue_free()


func _on_hit(always_destroy:bool = false) -> void:
	hit_points -=1
	if hit_points < 1:
		queue_free()
	pass # Replace with function body.

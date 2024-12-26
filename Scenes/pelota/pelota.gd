class_name pelota
extends CharacterBody2D

@export var SPEED = 350.0
@export var ACCELERATION_VALUE_STEP = 0.01
@export var MAX_SPEED_BOOST = 3

var acceleration = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
func _ready():	
	velocity = Vector2(SPEED, 0).rotated(1)	
	
func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision:
		rebotar(collision)
		golpear(collision)

func golpear(collision: KinematicCollision2D):
	var collider = collision.get_collider()	
	if collider.has_signal("hit"):
		collider.emit_signal("hit")
	if collider.has_signal("out"):
		queue_free()
		collider.emit_signal("out")

func rebotar(collision: KinematicCollision2D):	
	velocity = velocity.bounce(collision.get_normal())
	$Rebote.play()
	if acceleration < MAX_SPEED_BOOST:
		velocity /= acceleration
		acceleration += ACCELERATION_VALUE_STEP
		velocity *= acceleration
		
	#print("Acceleration of the ball is ", acceleration, velocity)

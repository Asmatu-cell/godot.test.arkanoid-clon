extends StaticBody2D
class_name bloqueController

signal hit

const PowerUpClass = preload("res://Scenes/PowerUps/powerUp.tscn")

var cooldown = 1
var destroyed = false
@export var hits = 1
@export var SPRITE_FOLDER_BASE = "bloques"
@export var SPRITE_BASE = "block-"
@export var BLOCK_FOLDER = ""
@export var POWER_UP_PROBABILITY: float = 0.25
@export var POWER_UP_TYPE: String = ""


func _ready() -> void:
	pass	

func _physics_process(delta):
	if destroyed:
		cooldown -= delta
		if cooldown <= 0:
			queue_free()
			cooldown = 1.0

# Called when the node enters the scene tree for the first time.
func set_hits(hitNumber:int):
	hits = hitNumber

func _on_hit(always_destroy:bool = false) -> void:
	hits -= 1
	if hits < 1 || always_destroy:
		$AudioBreak.play()
		visible = false
		destroy()
	else:		
		$AudioHit.play()
		var sprite = str("res://assets/" + SPRITE_FOLDER_BASE + "/" + BLOCK_FOLDER + "/", SPRITE_BASE + str(hits), ".png")
		if (sprite):
			get_node("Sprite2D").texture = load(sprite)
			
	pass # Replace with function body.

func destroy():	
	checkIfPowerUpAppears()
	destroyed = true
	visible = false
	position.y = 1000
	GameController.points_add(25)

func checkIfPowerUpAppears():
	var aleatorio = randf()
	print("Trying to create PowerUP ",  aleatorio)
	# Si el número aleatorio es menor o igual a la probabilidad, se realiza la acción	
	if aleatorio <= POWER_UP_PROBABILITY:
		create_power_up()
		
func create_power_up():
	var power_up:PowerUp = PowerUpClass.instantiate()
	power_up.position = position
	get_tree().current_scene.add_child(power_up)

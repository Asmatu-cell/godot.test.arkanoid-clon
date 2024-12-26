class_name PowerUp
extends Area2D

@export var force_type = ""

var powerUp = null
var speed = 150
# Diccionario con los tipos de power-ups
var powerUpTypes = {
	"Large": {
		"type": "Large",	
		"speed": 150,
		"scale": 1.5
	},
	"Small": {
		"type": "Small",
		"speed": 150,
		"scale": 0.5
	},
	"ExtraLife": {
		"type": "ExtraLife",
		"animation": "Extra",
		"speed": 150
	},
	"Contact": {
		"type": "Contact",
		"speed": 150
	},
	"Double": {
		"type": "Double",
		"speed": 150
	},
	"Fire": {
		"type": "Fire",
		"speed": 150
	},
	"Metal": {
		"type": "Metal",
		"speed": 150
	}
}

func _init(type: String = ""):
	if type != "" && powerUpTypes.has(type):
		self.powerUp = powerUpTypes[type]
	else:
		randomize()  # Inicializa el generador de números aleatorios		 
		var keys = powerUpTypes.keys()
		self.powerUp = powerUpTypes[keys[randi() % keys.size()]]


func _on_ready()-> void:
	if force_type:
		self.powerUp = powerUpTypes[force_type]		

	set_animation()
	set_speed()
	pass

func _process(delta):
	# Mover el objeto hacia abajo en cada frame
	position.y += speed * delta

# Llamada cuando otro cuerpo entra al área
func _on_body_entered(body: Node2D) -> void:
	print(body.name)
	if body.name == "Tabla":  # Asegúrate de comparar con el nombre correcto del objeto principal
		print("Power-up recogido!")
		match powerUp["type"]:
			"Small", "Large":
				power_up_change_tabla(body)  # Llama a la función que aumenta el tamaño de la tabla
			"ExtraLife":
				power_up_extra_life(body)  # Llama a la función que otorga una vida extra
			# Añadir más casos según sea necesario
			_:
				print("Tipo desconocido: ", powerUp)
		queue_free()  # Elimina el objeto del juego
	pass

func set_speed(new_speed:int = 0):
	self.speed = powerUp["speed"]	
	if new_speed:
		self.speed = new_speed

func set_animation(animation:String = ""):
	var newAnimation = powerUp["type"]

	if powerUp.has("animation"):
		newAnimation = powerUp["animation"]
	if animation != "":
		newAnimation = animation

	print("func set_animation: ", animation, newAnimation)
	$PowerUpAnimation.animation = newAnimation

#######################
####	POWER UPS	###
#######################

func power_up_change_tabla(tabla: Node2D):	
	print("func power_up_change_tabla: ", tabla)
	var tabla_obj = tabla as Tabla
	var new_width = tabla_obj.base_width_scale * powerUp["scale"]
	if new_width != tabla.scale.x:		
		tabla_obj.transition_elapsed_time = 0
		tabla_obj.new_width_scale = new_width
	#tabla.scale.x *= powerUp["scale"]
	pass

func power_up_extra_life(tabla: Node2D):
	print("func otorgar_vida_extra: ", tabla)

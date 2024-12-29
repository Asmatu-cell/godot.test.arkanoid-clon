class_name PowerUp
extends Area2D

const ESCENA_PELOTA = preload("res://Scenes/pelota/pelota.tscn")
signal power_up_obtained(item:PowerUp)

@export var force_type = ""

var powerUp = null
var speed = 150
# Diccionario con los tipos de power-ups
var powerUpTypes = {
	"Large": {
		"type": "Large",	
		"speed": 150,
		"scale": 1.5,
		"image_url": "res://Assets/powerups/simples/large.png"
	},
	"Small": {
		"type": "Small",
		"speed": 150,
		"scale": 0.5,
		"image_url": "res://Assets/powerups/simples/small.png"
	},
	"ExtraLife": {
		"type": "ExtraLife",
		"animation": "Extra",
		"speed": 150,
		"image_url": "res://Assets/powerups/simples/extra.png"
	},
	"Contact": {
		"type": "Contact",
		"speed": 150,
		"image_url": "res://Assets/powerups/simples/contact.png"
	},
	"Double": {
		"type": "Double",
		"speed": 150,
		"image_url": "res://Assets/powerups/simples/double.png"
	},
	"Fire": {
		"type": "Fire",
		"speed": 150,
		"image_url": "res://Assets/powerups/simples/fire.png"
	},
	"Metal": {
		"type": "Metal",
		"speed": 150,
		"image_url": "res://Assets/powerups/simples/metal.png"
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
	#print(body.name)
	if body.name == "Tabla":  # Asegúrate de comparar con el nombre correcto del objeto principal
		print("Power-up recogido!", powerUp)
		power_up_obtained.emit(self)
		GameController.points_add(150)
		GameController.reset_powers()
		
		match powerUp["type"]:
			"Small", "Large":
				power_up_change_tabla(body)  # Llama a la función que aumenta el tamaño de la tabla
			"ExtraLife":
				power_up_extra_life(body)  # Llama a la función que otorga una vida extra
			"Metal":
				power_up_metal_ball(body)  # Llama a la función que convierte la bola en destructora
			"Fire":
				power_up_fire(body)  # Llama a la función que deja disparar
			"Contact":
				power_up_contact(body)  # Llama a la función donde la bola se queda pegada
			"Double":
				power_up_double_balls(body)  # Llama a la función que duplica las bolas
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

func get_texture() -> CompressedTexture2D:	
	var image_path =  powerUp["image_url"]
	var compressed_texture = load(image_path)  # Preload te garantiza que la textura se cargue como comprimida
	return compressed_texture 

#######################
####	POWER UPS	###
#######################

func power_up_change_tabla(tabla: Node2D):
	var tabla_obj = tabla as Tabla
	var new_width = tabla_obj.base_width_scale * powerUp["scale"]
	if new_width != tabla.scale.x:		
		tabla_obj.transition_elapsed_time = 0
		tabla_obj.new_width_scale = new_width
	#tabla.scale.x *= powerUp["scale"]
	pass

func power_up_metal_ball(tabla: Node2D):
	var bola = get_tree().current_scene.find_children("Pelota*", "", false, false).pick_random()
	if bola:
		bola.emit_signal("ball_transform")
	pass
	
func power_up_fire(tabla: Node2D):
	GameController.modoDisparo = true;
	var tabla_obj = tabla as Tabla
	tabla_obj.find_child("Shoters Container").visible = true
	pass
func power_up_contact(tabla: Node2D):
	var tabla_obj = tabla as Tabla
	tabla_obj.emit_signal("set_contact_mode", true)
	pass
		
func power_up_extra_life(tabla: Node2D):
	GameController.life_changed(+1)
	print("func otorgar_vida_extra: ", tabla)

func power_up_double_balls(tabla: Node2D):
	var pelotasActuales = get_tree().current_scene.find_children("Pelota*", "", false, false)
	var pelotasActualesSize = pelotasActuales.size()
	if  pelotasActualesSize < 12:
		for i in pelotasActuales.size():
			#Instanciamos una nueva pelota
			var pelotaObject:pelota =  ESCENA_PELOTA.instantiate()
			pelotaObject.position = pelotasActuales[i].position
			get_tree().current_scene.add_child(pelotaObject)
			pelotaObject.velocity = pelotasActuales[i].velocity
			
			#Preparamos fuerzas y dirección de esta nueva pelota sobre la otra
			var n = randf()
			var n2 = 1 + n
			pelotaObject.velocity.x = pelotaObject.velocity.x * - n
			pelotaObject.velocity.y = pelotaObject.velocity.y * - n2
			pelotaObject.name = "Pelota"
			
			#Si ya hay suficientes pelotas, paramos.
			pelotasActualesSize += 1
			if  pelotasActualesSize < 12:
				pass
		#endfor
	#endif
	pass

class_name bloqueCyan
extends bloqueController

#@export var textura_spritesheet: Texture  # Asigna la imagen completa en el Inspector
#
#func _ready():
	#texture = textura_spritesheet  # Usa la imagen grande
	#set_estado(1)  # Para mostrar el segundo estado
	#set_estado(2)  # Para mostrar el tercer estado
#
#func set_estado(estado: int):
	#var ancho_sprite = 70  # Ajusta según el tamaño de cada imagen en el spritesheet
	#var alto_sprite = 30
	#region_enabled = true  # Activa el recorte de imagen
	#region_rect = Rect2(estado * ancho_sprite, 0, ancho_sprite, alto_sprite)
func _on_hit(always_destroy:bool = false) -> void:
	pass
	
func _ready() -> void:
	pass	

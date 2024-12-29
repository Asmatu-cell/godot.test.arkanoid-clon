class_name LaserBullet extends Area2D

# Señales
signal hit  # Señal que emite cuando el proyectil colisiona con algo

# Variables de configuración
var speed = 400  # Velocidad de movimiento del proyectil
var lifetime = 2  # Tiempo máximo que el proyectil existirá
var velocity = Vector2(0, -speed)  # Definir la velocidad del proyectil (se mueve hacia arriba)

func _ready():
	# Inicia el movimiento hacia arriba
	set_as_top_level(true)	# Para asegurar que el proyectil no herede transformaciones del nodo padre
	
	# Configura el temporizador para destruir el proyectil si no impacta
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = lifetime
	timer.one_shot = true
	
	# Conectar el temporizador correctamente con un Callable
	timer.connect("timeout", Callable(self, "_on_lifetime_timeout"))
	timer.start()
	
func _process(delta):
	# Mueve el proyectil hacia arriba
	position += velocity * delta
	
func _on_lifetime_timeout():
	# Si el proyectil no ha impactado, se destruye después de su tiempo de vida
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	emit_signal("hit", body)  # Emite la señal de impacto
	queue_free()  # El proyectil se destruye después del impacto
	pass # Replace with function body.

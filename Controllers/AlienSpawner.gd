extends Area2D

# Variable para el alien que quieres instanciar (arrástralo en el editor)
@export var alien_scene: PackedScene
# Intervalo entre spawns
@export var spawn_interval: float = 5.0
# Área de spawn (puedes definir los límites en el editor o por código)
@export var spawn_area: Rect2 = Rect2(Vector2.ZERO, Vector2(200, 200))
@export var max_aliens: int = 10
var count_aliens: int = 0

# Interna: Temporizador
var _timer: float = 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	if count_aliens < max_aliens:
		_timer += delta
		if _timer >= spawn_interval:
			_timer = 0.0
			count_aliens += 1
			spawn_alien()
		pass
func spawn_alien() -> void:
	# Instancia el alien
	if alien_scene:
		var alien:CharacterBody2D = alien_scene.instantiate()
		
		# Coloca al alien dentro del área definida
		var spawn_position = Vector2(
			global_position.x +  spawn_area.position.x,
			global_position.y + spawn_area.position.y
		)
		alien.position = spawn_position		
		# Añade al alien a la escena
		get_parent().add_child(alien)

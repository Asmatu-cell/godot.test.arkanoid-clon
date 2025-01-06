extends Node2D

@onready var start: Label = $Control/Start
@onready var label: Label = $Control/Label

@onready var number_1: Sprite2D = $Control/Number1
@onready var number_0: Sprite2D = $Control/Number0
@export var number_images:Dictionary = {}
#@export_enum("Rebecca", "Mary", "Leah") var character_name: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_level_numbers()	
	$Fade_transition/AnimationPlayer.play("fade_out")
	await get_tree().create_timer(1.5).timeout
	start.visible = true
	label.visible = false
	number_0.visible = false
	number_1.visible = false
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file(str("res://Scenes/Niveles/nivel_",GameController.get_current_level(),".tscn"))
	pass # Replace with function body.

func set_level_numbers():
	var level = GameController.get_current_level()
	var digits = []
	
	for char in str(level):
		digits.append(int(char))
	
	number_1.texture = number_images[digits[0]]
	if digits.size() > 1:
		number_0.texture  = number_images[digits[1]]
	else:
		number_1.texture = number_images[0]
		number_0.texture = number_images[digits[0]]
		
	pass

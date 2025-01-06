extends Node2D

var button_type = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	button_type = "start"
	call_fade_in()
	pass # Replace with function body.


func _on_options_pressed() -> void:
	button_type = "options"
	call_fade_in()
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.

func call_fade_in() -> void:
	$Fade_transition.show()
	$Fade_transition/fade_timer.start()
	$Fade_transition/AnimationPlayer.play("fade_in")
	
func _on_fade_timer_timeout() -> void:
	if button_type == "start":
		get_tree().change_scene_to_file("res://Scenes/UI/new_level_screen.tscn")
	elif button_type == "options":
		get_tree().change_scene_to_file("res://Scenes/UI/new_level_screen.tscn")

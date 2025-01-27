extends PanelContainer
const V_BOX_POWER_UP_CONTAINER = preload("res://Scenes/UI/v_box_powerUpContainer.tscn")
@onready var v_box_container: VBoxContainer = $VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func add_item(item:PowerUp) -> void:
	var power_up_item = V_BOX_POWER_UP_CONTAINER.instantiate()
	power_up_item.initialize(item.get_texture(), item.powerUp.type)
	v_box_container.add_child(power_up_item)
	if v_box_container.get_child_count() > 4:
		v_box_container.remove_child(v_box_container.get_child(1))

func on_powerup_collected(item:PowerUp) :
	add_item(item)

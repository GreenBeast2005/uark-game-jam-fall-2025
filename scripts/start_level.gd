extends Button

@export var scene_to_load: PackedScene

func _ready():
	pressed.connect(_on_button_pressed)

func _on_button_pressed():
	if scene_to_load:
		get_tree().change_scene_to_packed(scene_to_load)

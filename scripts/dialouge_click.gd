extends Area2D

@export var dialogue_texts: Array[String] = []
@export var dialogue_manager: Node  # Reference to the dialogue node

func _ready():
    # Connect the input_event signal from Area2D
    input_event.connect(_on_input_event)

func _on_input_event(viewport, event, shape_idx):
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        if dialogue_texts.size() > 0 and dialogue_manager:
            dialogue_manager.start_dialogue(dialogue_texts)

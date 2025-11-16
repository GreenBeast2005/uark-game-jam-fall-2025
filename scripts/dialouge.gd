extends Node

@export var dialogue_text_label: RichTextLabel

var current_dialogue_texts: Array[String] = []
var current_dialogue_index: int = 0
var dialogue_active: bool = false

func _ready():
    # Hide dialogue initially
    if dialogue_text_label:
        dialogue_text_label.get_parent().visible = false

func _input(event):
    if dialogue_active and event.is_pressed():
        if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
            _on_click()
        elif event is InputEventKey and event.keycode == KEY_SPACE:
            _on_click()

func start_dialogue(text_array: Array[String]):
    if text_array.size() == 0:
        return
        
    current_dialogue_texts = text_array
    current_dialogue_index = 0
    dialogue_active = true
    
    # Show dialogue UI
    if dialogue_text_label:
        dialogue_text_label.get_parent().visible = true
        display_current_text()

func display_current_text():
    if current_dialogue_index < current_dialogue_texts.size():
        dialogue_text_label.text = current_dialogue_texts[current_dialogue_index]

func _on_click():
    if not dialogue_active:
        return
        
    current_dialogue_index += 1
    
    if current_dialogue_index >= current_dialogue_texts.size():
        # End of dialogue
        end_dialogue()
    else:
        # Show next text
        display_current_text()

func end_dialogue():
    dialogue_active = false
    current_dialogue_index = 0
    current_dialogue_texts.clear()
    
    # Hide dialogue UI
    if dialogue_text_label:
        dialogue_text_label.get_parent().visible = false

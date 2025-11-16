extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree

@export var dialogue: DialogueResource
var direction: Vector2 = Vector2.ZERO

# Player movement constants
@export var SPEED = 300.0
@export var ACCELERATION = 1500.0
@export var FRICTION = 1200.0

func _ready() -> void:
	add_to_group("player")
	animation_tree.active = true

func _physics_process(delta):
	# Get input direction for both axes
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_axis("ui_left", "ui_right")
	input_vector.y = Input.get_axis("ui_up", "ui_down")
	
	# Normalize diagonal movement to prevent faster diagonal speed
	if input_vector.length() > 1:
		input_vector = input_vector.normalized()
	
	# Handle movement with acceleration and friction
	if input_vector != Vector2.ZERO:
		# Apply acceleration when moving
		velocity = velocity.move_toward(input_vector * SPEED, ACCELERATION * delta)
	else:
		# Apply friction when not moving
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	# Move the character
	move_and_slide()


func _process(delta: float) -> void:
	var camera = get_viewport().get_camera_2d()
	if camera:
		camera.global_position = global_position

	if velocity != Vector2.ZERO:
		direction = velocity.normalized()
	_update_animation_parametsers()

func _update_animation_parametsers() -> void:
	if(velocity == Vector2.ZERO):
		animation_tree.set("parameters/conditions/idle", true)
		animation_tree.set("parameters/conditions/is_walking", false)
	else:
		animation_tree.set("parameters/conditions/idle", false)
		animation_tree.set("parameters/conditions/is_walking", true)

	if direction != Vector2.ZERO:
		animation_tree.set("parameters/Idle/blend_position", direction)
		animation_tree.set("parameters/Walk/blend_position", direction)
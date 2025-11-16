extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_timer: Timer = $Timer

@export var speed: float = 100.0
@export var death_scene: PackedScene

var player: Node2D

func _ready():
	# Find the player node (assuming it has a group "player" or specific name)
	animation_player.play("walk")
	attack_timer.timeout.connect(_start_attack)
	player = get_tree().get_first_node_in_group("player")
	if not player:
		player = get_node("../Player") # Adjust path as needed

func _physics_process(delta):
	if player:
		# Calculate direction to player
		var direction = (player.global_position - global_position).normalized()
		
		# Only move if not attacking
		if animation_player.current_animation != "attack":
			velocity = direction * speed
			move_and_slide()
		else:
			velocity = Vector2.ZERO
		
		# Check for collision with player
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			if collision.get_collider() == player:
				_transition_to_death_scene()


func _start_attack():
	attack_timer.stop()  # Stop the timer during attack
	animation_player.play("attack")
	# Wait for attack animation to finish, then resume walking
	await animation_player.animation_finished
	animation_player.play("walk")
	attack_timer.start()  # Restart the timer after walk begins

func _transition_to_death_scene():
	if death_scene and get_tree():
		get_tree().change_scene_to_packed(death_scene)

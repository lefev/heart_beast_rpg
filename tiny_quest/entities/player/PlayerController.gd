extends KinematicBody2D

# Constants
# Movement
const MAX_SPEED : float = 80.0
const ACCELERATION : float = 600.0
const FRICTION : float = 600.0

# vars
var velocity : Vector2 = Vector2.ZERO

onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var animation_tree : AnimationTree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")

# methods
func _get_movement_input() -> Vector2:
	var movement_input : Vector2 = Vector2.ZERO
	movement_input.x = Input.get_action_strength('move_right') - Input.get_action_strength('move_left')
	movement_input.y = Input.get_action_strength('move_down') - Input.get_action_strength('move_up')
	movement_input = movement_input.normalized()
	return movement_input
	
# processes
func _physics_process(delta: float) -> void:
	var movement_input : Vector2 = _get_movement_input()
	
	if movement_input != Vector2.ZERO:
		animation_tree.set("parameters/idle/blend_position", movement_input)
		animation_tree.set("parameters/run/blend_position", movement_input)
		animation_state.travel("run")
		velocity = velocity.move_toward(movement_input * MAX_SPEED, ACCELERATION * delta)
	else:
		animation_state.travel("idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)


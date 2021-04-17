extends KinematicBody2D

# Constants
# Movement
const MAX_SPEED : float = 100.0
const ACCELERATION : float = 10.0
const FRICTION : float = 10.0

# vars
var velocity : Vector2 = Vector2.ZERO

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
		velocity += movement_input * ACCELERATION * delta
		velocity = velocity.clamped(MAX_SPEED * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move_and_collide(velocity)

extends KinematicBody2D

# Constants
# Movement
export var MAX_SPEED : float = 80.0
export var ROLL_SPEED : float = MAX_SPEED * 1.4
export var ACCELERATION : float = 600.0
export var FRICTION : float = 600.0

enum {
	MOVE,
	ROLL,
	ATTACK
}

# vars
var current_state = MOVE 
var velocity : Vector2 = Vector2.ZERO
var velocity_roll : Vector2 = Vector2.DOWN
var stats = PlayerStats

onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var blink_animation_player : AnimationPlayer = $BlinkAnimationPlayer
onready var animation_tree : AnimationTree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var sword_hitbox : Area2D = $HitboxPivot/SwordHitBox
onready var hurtbox = $HurtBox
const hurt_sound = preload("res://music_and_sound/PlayerHurtSound.tscn")


func _ready()  -> void:
	stats.connect("no_health", self, "queue_free")
	animation_tree.active = true
	sword_hitbox.knockback = velocity_roll


func _physics_process(delta: float) -> void:
	match current_state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state()
		ATTACK:
			attack_state()


func _get_movement_input() -> Vector2:
	var movement_input : Vector2 = Vector2.ZERO
	movement_input.x = Input.get_action_strength('move_right') - Input.get_action_strength('move_left')
	movement_input.y = Input.get_action_strength('move_down') - Input.get_action_strength('move_up')
	movement_input = movement_input.normalized()
	return movement_input


func move_state(delta : float) -> void:
	var movement_input : Vector2 = _get_movement_input()
	
	if movement_input != Vector2.ZERO:
		sword_hitbox.knockback = movement_input
		velocity_roll = movement_input
		animation_tree.set("parameters/idle/blend_position", movement_input)
		animation_tree.set("parameters/run/blend_position", movement_input)
		animation_tree.set("parameters/attack/blend_position", movement_input)
		animation_tree.set("parameters/roll/blend_position", movement_input)
		animation_state.travel("run")
		velocity = velocity.move_toward(movement_input * MAX_SPEED, ACCELERATION * delta)
	else:
		animation_state.travel("idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("roll"):
		current_state = ROLL

	
	if Input.is_action_just_pressed("attack"):
		current_state = ATTACK


func roll_animation_finished() -> void:
	current_state = MOVE


func roll_state() -> void:
	velocity = velocity_roll * ROLL_SPEED
	animation_state.travel("roll")
	move()
	

func attack_state() -> void:
	# Stop sliding while attacking
	velocity = Vector2.ZERO
	animation_state.travel("attack")
	

func attack_animation_finished() -> void:
	current_state = MOVE
	# magic number x.x
	velocity = velocity * 0.8
	

func move() -> void:
	velocity = move_and_slide(velocity)


func _on_HurtBox_area_entered(area: Area2D) -> void:
	stats.health -= area.damage
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect()
	var hurt_sound_instance = hurt_sound.instance()
	get_tree().current_scene.add_child(hurt_sound_instance)
	

func _on_HurtBox_invincibility_started() -> void:
	blink_animation_player.play("Start")


func _on_HurtBox_invincibility_ended() -> void:
	blink_animation_player.play("End")

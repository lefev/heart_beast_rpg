extends KinematicBody2D

# preloads
const death_animation = preload("res://effects/EnemyDeathEffect.tscn")

# states
enum {
	IDLE,
	WANDER,
	CHASE
}
onready var current_state = pick_random_state([IDLE, WANDER])

# vars
onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var detection_zone = $DetectionZone
onready var hurtbox = $HurtBox
onready var soft_collision = $SoftCollision
onready var wander_controller = $WanderController
onready var blink_animation_player = $BlinkAnimationPlayer

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

# exports
export var acceleration = 500
export var friction = 200
export var wander_distance = 4

func _ready() -> void:
	randomize()

func _physics_process(delta: float) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, friction * delta)
	knockback = move_and_slide(knockback)
	
	match current_state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()
			if wander_controller.get_time_left() == 0:
				update_random_state()
			
		WANDER:
			seek_player()
			if wander_controller.get_time_left() == 0:
				update_random_state()
				accelerate_towards(wander_controller.target_position, delta)
				
				if global_position.distance_to(wander_controller.target_position) <= wander_distance:
					update_random_state()
			
		CHASE:
			var player = detection_zone.player
			if player != null:
				accelerate_towards(player.global_position, delta)
			else:
				current_state = IDLE
			
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * delta * 400
	if velocity != Vector2.ZERO:
		sprite.flip_h = velocity.x < 0
	velocity = move_and_slide(velocity)


func pick_random_state(state_list : Array):
	state_list.shuffle()
	return state_list.pop_front()


func update_random_state():
	current_state = pick_random_state([IDLE, WANDER])
	wander_controller.start_wander_timer(rand_range(1, 3))


func accelerate_towards(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * stats.max_speed, acceleration * delta)


func seek_player() -> void:
	if detection_zone.can_see_player():
		current_state = CHASE
	

func _on_HurtBox_area_entered(area) -> void:
	stats.health -= area.damage
	knockback = area.knockback * 120
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.3)


func _on_Stats_no_health() -> void:
	queue_free()
	var death_animation_instance = death_animation.instance()
	get_parent().add_child(death_animation_instance)
	death_animation_instance.global_position = global_position


func _on_HurtBox_invincibility_ended() -> void:
	blink_animation_player.play("End")


func _on_HurtBox_invincibility_started() -> void:
	blink_animation_player.play("Start")

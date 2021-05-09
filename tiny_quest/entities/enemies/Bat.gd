extends KinematicBody2D

# preloads
const death_animation = preload("res://effects/EnemyDeathEffect.tscn")

# states
enum {
	IDLE,
	WANDER,
	CHASE
}
var current_state = IDLE

# vars
onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var detection_zone = $DetectionZone
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

# exports
export var acceleration = 300
export var friction = 200


func _physics_process(delta: float) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, friction * delta)
	knockback = move_and_slide(knockback)
	
	match current_state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()
			
		WANDER:
			pass
		CHASE:
			var player = detection_zone.player
			if player != null:
				sprite.flip_h = velocity.x < 0
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(direction * stats.max_speed, acceleration * delta)
			else:
				current_state = IDLE
	
	velocity = move_and_slide(velocity)


func seek_player() -> void:
	if detection_zone.can_see_player():
		current_state = CHASE
	

func _on_HurtBox_area_entered(area) -> void:
	stats.health -= area.damage
	knockback = area.knockback * 120


func _on_Stats_no_health() -> void:
	queue_free()
	var death_animation_instance = death_animation.instance()
	get_parent().add_child(death_animation_instance)
	death_animation_instance.global_position = global_position

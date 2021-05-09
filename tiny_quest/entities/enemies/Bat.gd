extends KinematicBody2D

var knockback = Vector2.ZERO

const death_animation = preload("res://effects/EnemyDeathEffect.tscn")
onready var stats = $Stats

func _physics_process(delta: float) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)

func _on_HurtBox_area_entered(area) -> void:
	stats.health -= area.damage
	knockback = area.knockback * 120

func _on_Stats_no_health() -> void:
	queue_free()
	var death_animation_instance = death_animation.instance()
	get_parent().add_child(death_animation_instance)
	death_animation_instance.global_position = global_position

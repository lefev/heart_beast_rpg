extends Area2D

const hit_effect = preload("res://effects/HitEffect.tscn")

var invincible : bool = false setget set_invincible
onready var timer : Timer = $Timer
onready var collision_shape : CollisionShape2D = $CollisionShape2D

signal invincibility_started
signal invincibility_ended

func set_invincible(value : bool) -> void:
	invincible = value
	if invincible:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")


func start_invincibility(duration) -> void:
	timer.start(duration)
	self.invincible = true
	

func create_hit_effect() -> void:
	var hit_effect_instance = hit_effect.instance()
	var main = get_tree().current_scene
	main.add_child(hit_effect_instance)
	hit_effect_instance.global_position = global_position


func _on_Timer_timeout() -> void:
	self.invincible = false


func _on_HurtBox_invincibility_started() -> void:
	collision_shape.set_deferred("disabled", true)


func _on_HurtBox_invincibility_ended() -> void:
	collision_shape.disabled = false

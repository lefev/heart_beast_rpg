extends Node

# Health
export(int) var max_health = 5
onready var health = max_health setget set_health

signal no_health

func set_health(value) -> void:
	health = value
	if health <= 0:
		emit_signal("no_health")

# Movement
export(int) var max_speed = 50 setget set_max_speed, get_max_speed

func set_max_speed(var value) -> void:
	max_speed = value

func get_max_speed() -> int:
	return max_speed

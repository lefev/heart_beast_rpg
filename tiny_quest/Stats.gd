extends Node

# Health
export(int) var max_health = 4 setget set_max_health
onready var health = max_health setget set_health

signal no_health
signal health_changed(value)
signal max_health_changed(value)

func set_health(value) -> void:
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")


func set_max_health(value) -> void:
	max_health = max(value, 1)
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)


# Movement
export(int) var max_speed = 50 setget set_max_speed, get_max_speed

func set_max_speed(var value) -> void:
	max_speed = value

func get_max_speed() -> int:
	return max_speed

func _ready():
	self.health = max_health

extends Node2D

export(int) var wander_distance = 50

onready var start_position = global_position
onready var target_position = global_position

onready var timer = $Timer

func _ready() -> void:
	update_target_position()


func update_target_position():
	var target = Vector2(rand_range(-wander_distance, wander_distance), rand_range(-wander_distance, wander_distance))
	target_position = start_position + target


func start_wander_timer(duration):
	timer.start(duration)
	

func get_time_left():
	return timer.time_left


func _on_Timer_timeout() -> void:
	update_target_position()

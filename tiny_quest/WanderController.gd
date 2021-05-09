extends Node2D

onready var start_position = global_position
onready var target_position = global_position
export(int) var wander_distance = 32

func _ready() -> void:
	update_target_position()

func update_target_position():
	var target = Vector2(rand_range(wander_distance, -wander_distance), rand_range(wander_distance, -wander_distance))
	target_position = start_position + target

func set_timer(duration):
	$Timer.start(duration)
	

func get_time_left():
	return $Timer.time_left


func _on_Timer_timeout() -> void:
	update_target_position()

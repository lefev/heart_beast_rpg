extends StaticBody2D

onready var fruitbat = preload("res://entities/enemies/Bat.tscn")
onready var timer = $SpawnTimer
onready var spawn_point = $SpawnPoint

export(float) var spawn_timer_end = 5
export(float) var spawn_timer_begin = 1
export(int) var max_spawned = 5
var currently_spawned = 0


func _ready() -> void:
	timer.start(rand_range(spawn_timer_begin, spawn_timer_end))


func spawn_fruitbat():
	if currently_spawned >= max_spawned:
		return
	var fruitbat_instance = fruitbat.instance()
	get_tree().current_scene.add_child(fruitbat_instance)
	fruitbat_instance.position = spawn_point.global_position
	currently_spawned += 1
	fruitbat_instance.connect("remove_fruitbat", self, "_on_fruitbat_death")


func _on_fruitbat_death():
	currently_spawned -= 1


func _on_SpawnTimer_timeout() -> void:
	spawn_fruitbat()
	timer.start(rand_range(spawn_timer_begin, spawn_timer_end))

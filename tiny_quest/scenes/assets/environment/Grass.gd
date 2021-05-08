extends Node2D

func create_grass_effect():
	var GrassEffect = load("res://effects/GrassEffect.tscn")
	var grassEffect = GrassEffect.instance()
	var main = get_tree().current_scene
	main.add_child(grassEffect)
	grassEffect.global_position = global_position


func _on_HurtBox_area_entered(_area: Area2D) -> void:
	create_grass_effect()
	queue_free()

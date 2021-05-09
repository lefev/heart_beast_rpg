extends Area2D

export(bool) var show_hit_effect = false

const hit_effect = preload("res://effects/HitEffect.tscn")

func _on_HurtBox_area_entered(area: Area2D) -> void:
	if show_hit_effect:
		var hit_effect_instance = hit_effect.instance()
		var main = get_tree().current_scene
		main.add_child(hit_effect_instance)
		hit_effect_instance.global_position = global_position

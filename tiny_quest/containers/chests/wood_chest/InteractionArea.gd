extends Area2D

signal interaction_start
signal interaction_end

func _on_InteractionArea_area_entered(_area):
	emit_signal("interaction_start")


func _on_InteractionArea_area_exited(_area):
	emit_signal("interaction_end")

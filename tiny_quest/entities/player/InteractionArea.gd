extends Area2D

onready var default_interaction_image = preload("res://ui/interaction/default_icon.png")

var can_interact = false
var current_area = null

func _process(delta):
	if current_area == null:
		return
	if Input.is_action_just_pressed("interact"):
		current_area.interact()
		
	
func _on_InteractionArea_area_entered(area : Area2D):
	if area.has_method("interact"):
		area.show_interaction(self)
		current_area = area


func _on_InteractionArea_area_exited(area : Area2D):
	if area == current_area:
		current_area = null

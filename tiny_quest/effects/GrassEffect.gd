extends Node2D

onready var animated_sprite = $AnimatedSprite

func _ready() -> void:
	play_from("Animate", 0)

func play_from(var animation_name ,var frame) -> void:
	animated_sprite.frame = frame
	animated_sprite.play(animation_name)

func _on_AnimatedSprite_animation_finished() -> void:
	queue_free()

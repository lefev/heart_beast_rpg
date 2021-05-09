extends AnimatedSprite

func _ready() -> void:
	var error = connect("animation_finished", self, "_on_animation_finished")
	if error:
		print_debug("couldn't connect animation_finished -> _on_animation_finished")
	play_from("Animation", 0)

func play_from(var animation_name ,var frame) -> void:
	frame = frame
	play(animation_name)

func _on_animation_finished() -> void:
	queue_free()

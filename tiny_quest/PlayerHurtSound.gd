extends AudioStreamPlayer

func _ready() -> void:
	# clears the audio player even if the finished signal cannot be connected
	if connect("finished", self, "queue_free") != 0:
		queue_free()

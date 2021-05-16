extends TextureRect

onready var default_texture = preload("res://ui/interaction/default_icon.png")

func _ready():
	set_texture(default_texture)

func set_texture(new_texture : Texture):
	self.texture = new_texture

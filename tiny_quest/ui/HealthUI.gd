extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

const heart_size = 32
onready var heart_full : TextureRect = $HeartUIFull
onready var heart_empty : TextureRect  = $HeartUIEmpty
onready var stats = PlayerStats

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if heart_empty != null:
		heart_full.rect_size.x = hearts * heart_size


func set_max_hearts(value):
	max_hearts = max(value, 1)
	if heart_empty != null:
		heart_empty.rect_size.x = max_hearts * heart_size
	

func _ready():
	self.max_hearts = stats.max_health
	self.hearts = stats.health
	stats.connect("health_changed", self, "set_hearts")
	stats.connect("max_health_changed", self, "set_max_hearts")

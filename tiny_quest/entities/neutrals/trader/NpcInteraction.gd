extends Area2D

export(Texture) onready var texture = preload("res://entities/neutrals/trader/trader.png")
var interaction_ui = null
var talk_ui = null

func _ready():
	interaction_ui = get_tree().current_scene.find_node("InteractionUI")
	talk_ui = get_tree().current_scene.find_node("TalkBox")

func interact():
	talk_ui.visible = true
	
func show_interaction(_player_area):
	interaction_ui.set_texture(texture)

extends Sprite

onready var interaction_area : Area2D = $InteractionArea
onready var interaction_message : Panel = $InteractionMessage
onready var content_panel : ItemList = $ItemList

var can_interact : bool = false
var chest_content : Array = ["Sword", "Bow"]

enum State{OPEN, CLOSE}
var current_state = State.CLOSE

func _ready() -> void:
	if interaction_area.connect("interaction_start", self, "_on_interaction_enter") != 0:
		print_debug("interaction_start wasn't connected")
	if interaction_area.connect("interaction_end", self, "_on_interaction_exit") != 0:
		print_debug("interaction_end wasn't connected")

func _on_interaction_enter() -> void:
	interaction_message.visible = true
	can_interact = true
	
func _on_interaction_exit() -> void:
	interaction_message.visible = false
	
func display_content() -> void:
	content_panel.visible = true
	for content in chest_content:
		print_debug(content)

func open_chest() -> void:
	current_state = State.OPEN
	display_content()

func close_chest() -> void:
	current_state = State.CLOSE

func _process(_delta) -> void:
	if !can_interact:
		return
	
	match current_state:
		State.OPEN:
			if Input.is_action_just_pressed("interact"):
				close_chest()
		State.CLOSE:
			if Input.is_action_just_pressed("interact"):
				open_chest()

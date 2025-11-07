extends Node

@onready var pause_menu = $"../UI/PauseMenu"

var game_paused: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"): # ui_cancel это Esc (эскейп)
		game_paused = !game_paused

	if game_paused == true:
		get_tree().paused = true
		pause_menu.show()
	else:
		get_tree().paused = false
		pause_menu.hide()

func _on_resume_pressed() -> void:
	game_paused = false

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scn/menu/menu.tscn")

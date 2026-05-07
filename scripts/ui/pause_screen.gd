extends CanvasLayer

@onready var resume_button: Button = %ResumeButton
@onready var quit_button: Button = %QuitButton

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	MusicPlayer.stop_music()
	ButtonManager.setup_buttons([resume_button, quit_button])
	resume_button.grab_focus()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	queue_free()
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

func _on_resume_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().paused = false
	MusicPlayer.resume()
	queue_free()

extends Control

@onready var back_button: Button = %BackButton
@onready var timer_label: Label = %TimeLabel
@onready var kills_label: Label = %KillsLabel
@onready var gold_label: Label = %GoldLabel

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	MusicPlayer.stop_music()
	ButtonManager.setup_buttons([back_button])
	back_button.grab_focus()
	
	var survival_time = int(GameTimer.seconds())
	var gold_earned = survival_time + SaveManager.current_gold

	timer_label.text = "%02d:%02d" % [int(GameTimer.seconds()) / 60, int(GameTimer.seconds()) % 60]
	kills_label.text = "%d" % SaveManager.current_kills
	gold_label.text = "+ %d" % gold_earned
	
	SaveManager.add_gold(gold_earned)
	SaveManager.on_game_over(survival_time)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

extends Control

@onready var start_button: Button = %StartGameButton
@onready var upgrade_button: Button = %UpgradeButton
@onready var exit_button: Button = %ExitButton
@onready var kills_label: Label = %KillsLabel
@onready var time_label: Label = %TimeLabel
@onready var gold_label: Label = %GoldLabel

func _ready():
	MusicPlayer.set_volume(1.0)
	MusicPlayer.play_music(preload("res://assets/music/Moonlit Melody.mp3"))
	ButtonManager.setup_buttons([start_button, upgrade_button, exit_button])
	start_button.grab_focus()
	#SaveManager.reset_save()
	
	kills_label.text = str(SaveManager.best_kills)
	time_label.text = "%02d:%02d" % [int(SaveManager.best_time) / 60, int(SaveManager.best_time) % 60]
	gold_label.text = str(SaveManager.gold)

func _on_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/hero_selection.tscn")

func _on_upgrade_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/upgrade_screen.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()

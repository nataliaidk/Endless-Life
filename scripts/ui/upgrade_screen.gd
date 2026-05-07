extends Control

@onready var icon: TextureRect = %HeroIcon
@onready var name_label: Label = %NameLabel
@onready var gold_label: Label = %GoldLabel
@onready var cost_label: Label = %CostLabel
@onready var health_label: Label = %HealthLabel
@onready var speed_label: Label = %SpeedLabel
@onready var luck_label: Label = %LuckLabel
@onready var health_button: Button = %HealthButton
@onready var speed_button: Button = %SpeedButton
@onready var luck_button: Button = %LuckButton
@onready var back_button: Button = %BackButton
@onready var health_segments: Container = %HealthSegments
@onready var speed_segments: Container = %SpeedSegments
@onready var luck_segments: Container = %LuckSegments
@onready var audio_purchase = $AudioPlayerPurchase
@onready var audio_buzz = $AudioPlayerBuzz

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	SaveManager.gold_changed.connect(_update_ui)
	SaveManager.stats_changed.connect(_update_ui)
	ButtonManager.setup_buttons([health_button, speed_button, luck_button, back_button])
	back_button.grab_focus()
	_update_ui()

func _update_ui() -> void:
	var h = SaveManager.all_heroes[0]
	var i = 0
	icon.texture = h.icon
	name_label.text = h.hero_name
	gold_label.text = str(SaveManager.gold)
	cost_label.text = "COST: %d" % SaveManager.upgrade_cost
	health_label.text = "HEALTH: %d" % SaveManager.get_stat(i, "max_health", h.max_health)
	speed_label.text = "SPEED: %d" % SaveManager.get_stat(i, "speed", h.speed)
	luck_label.text = "LUCK: %d" % SaveManager.get_stat(i, "luck", h.luck)

	if SaveManager.get_level(i, "max_health") >= 10:
		health_button.text = "MAX"
	if SaveManager.get_level(i, "speed") >= 10:
		speed_button.text = "MAX"
	if SaveManager.get_level(i, "luck") >= 10:
		luck_button.text = "MAX"

	draw_segments(health_segments, SaveManager.get_level(0, "max_health"), Color(0.639, 0.278, 0.278))
	draw_segments(speed_segments, SaveManager.get_level(0, "speed"), Color(0.290, 0.498, 0.710))
	draw_segments(luck_segments, SaveManager.get_level(0, "luck"), Color(0.247, 0.643, 0.416))

func draw_segments(container: HBoxContainer, level: int, active_color: Color) -> void:
	for child in container.get_children():
		child.queue_free()
	for i in 10:
		var segment = Panel.new()
		segment.custom_minimum_size = Vector2(8, 8)
		var style = StyleBoxFlat.new()
		style.bg_color = active_color if i < level else Color(0.2, 0.2, 0.2)
		style.corner_radius_top_left = 2
		style.corner_radius_top_right = 2
		style.corner_radius_bottom_left = 2
		style.corner_radius_bottom_right = 2
		segment.add_theme_stylebox_override("panel", style)
		container.add_child(segment)

func _can_upgrade(stat: String) -> bool:
	var i = 0
	return SaveManager.gold >= SaveManager.upgrade_cost and SaveManager.get_level(i, stat) < 10

func _on_upgrade_health() -> void:
	if _can_upgrade("max_health"):
		audio_purchase.play()
		SaveManager.upgrade_hero_stat(SaveManager.selected_hero_index, "max_health")
	else:
		audio_buzz.play()

func _on_upgrade_speed() -> void:
	if _can_upgrade("speed"):
		audio_purchase.play()
		SaveManager.upgrade_hero_stat(SaveManager.selected_hero_index, "speed")
	else:
		audio_buzz.play()

func _on_upgrade_luck() -> void:
	if _can_upgrade("luck"):
		audio_purchase.play()
		SaveManager.upgrade_hero_stat(SaveManager.selected_hero_index, "luck")
	else:
		audio_buzz.play()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")

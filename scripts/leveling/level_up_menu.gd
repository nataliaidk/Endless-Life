extends CanvasLayer

const HOVER_SOUND := preload("res://assets/sounds/button hover.mp3")

var _current_choices: Array[Dictionary] = []

@onready var leveling       = get_parent().get_node("LevelManager")
@onready var audioPlayer    = get_parent().get_node("LevelUpAudioPlayer")
@onready var ui_hover_audio = get_parent().get_node("ButtonsAudioPlayer")

@onready var level_up_panel: PanelContainer = %LevelUpPanel
@onready var level_title: Label             = %LevelTitle
@onready var level_up_buttons: Array[Button] = [
	%ChoiceButton0, %ChoiceButton1, %ChoiceButton2
]

func _ready():
	ui_hover_audio.stream = HOVER_SOUND
	leveling.level_up_ready.connect(_on_level_up_ready)

	for i in range(level_up_buttons.size()):
		if i > 0:
			level_up_buttons[i].focus_neighbor_left = level_up_buttons[i - 1].get_path()
		if i < level_up_buttons.size() - 1:
			level_up_buttons[i].focus_neighbor_right = level_up_buttons[i + 1].get_path()
		level_up_buttons[i].mouse_entered.connect(_on_ui_hover)
		level_up_buttons[i].focus_entered.connect(_on_ui_hover)
		level_up_buttons[i].pressed.connect(_on_choice_pressed.bind(i))

	level_up_panel.visible = false

func _on_level_up_ready(choices: Array[Dictionary]):
	audioPlayer.play()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_current_choices = choices
	level_title.text = "LEVEL %d → %d" % [leveling.player_level, leveling.player_level + 1]

	if choices.is_empty():
		level_up_panel.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		get_tree().paused = false
		return

	for i in range(level_up_buttons.size()):
		if i >= choices.size():
			level_up_buttons[i].visible = false
			continue

		level_up_buttons[i].visible = true
		var u: Dictionary = choices[i]
		var is_new: bool = u.get("is_new", false)
		var header := "NEW" if is_new else _to_roman(u["level"])

		level_up_buttons[i].text = "%s\n%s\n%s" % [
			u["name"],
			header,
			_format_bonus(u["bonus_preview"])
		]
		level_up_buttons[i].icon = u["icon"]

	level_up_panel.visible = true
	get_tree().paused = true
	level_up_buttons[0].grab_focus()

func _on_choice_pressed(index: int):
	level_up_panel.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().paused = false
	leveling.on_upgrade_chosen(index, _current_choices)

func _on_ui_hover() -> void:
	if ui_hover_audio.playing:
		ui_hover_audio.stop()
	ui_hover_audio.play()
	
func _format_bonus(bonus: ItemLevelData) -> String:
	var parts: Array[String] = []

	if bonus.xp_gain > 0:
		parts.append("XP Gain +%d" % bonus.xp_gain)
	if bonus.gold_gain > 0:
		parts.append("Gold Gain +%d" % bonus.gold_gain)
	if bonus.pickup_range > 0:
		parts.append("Pickup Range +%d" % bonus.pickup_range)
	if bonus.effect_duration > 0:
		parts.append("Effect Duration +%d" % bonus.effect_duration)
	if bonus.luck > 0:
		parts.append("Luck +%d" % bonus.luck)
	if bonus.attack_size > 0:
		parts.append("Attack Size +%d" % bonus.attack_size)
	if bonus.shield > 0:
		parts.append("Shield +%d" % bonus.shield)
	if bonus.move_speed > 0:
		parts.append("Move Speed +%d" % bonus.move_speed)
	if bonus.max_hp > 0:
		parts.append("Max HP +%d" % bonus.max_hp)
	if bonus.hp_regen > 0:
		parts.append("HP Regen +%d" % bonus.hp_regen)
	if bonus.attack_speed > 0:
		parts.append("Attack Speed +%d" % bonus.attack_speed)
	if bonus.projectile_count > 0:
		parts.append("Projectile Count +%d" % bonus.projectile_count)
	if bonus.holy_damage > 0:
		parts.append("Holy Damage +%d" % bonus.holy_damage)
	if bonus.fire_damage > 0:
		parts.append("Fire Damage +%d" % bonus.fire_damage)
	if bonus.blood_damage > 0:
		parts.append("Blood Damage +%d" % bonus.blood_damage)
	if bonus.physical_damage > 0:
		parts.append("Physical Damage +%d" % bonus.physical_damage)
	return "\n".join(parts)

func _to_roman(n: int) -> String:
	var romans := ["I", "II", "III", "IV", "V"]
	return romans[clampi(n - 1, 0, romans.size() - 1)]

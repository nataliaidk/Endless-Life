extends CanvasLayer

const UI_FONT := preload("res://assets/fonts/Gothikka.ttf")

var kills: int = 0
var kills_label: Label
var exp_progress_bar: ProgressBar

@onready var player   = get_parent()
@onready var leveling = get_parent().get_node("PlayerLeveling")
@onready var time_label: Label

func _ready():
	layer = 20
	_build_ui()
	player.exp_gained.connect(_on_player_exp_gained)
	leveling.upgrade_applied.connect(_on_upgrade_applied)
	_refresh_exp_bar()

func _process(_delta):
	var minutes := int(GameTimer.seconds()) / 60
	var secs := int(GameTimer.seconds()) % 60
	time_label.text = "%d:%02d" % [minutes, secs]

func add_kill():
	kills += 1
	_update_kills_label()

func _update_kills_label():
	kills_label.text = str(kills)

func _build_ui():
	var hud := Control.new()
	hud.set_anchors_preset(Control.PRESET_TOP_WIDE)
	hud.offset_left = 0
	hud.offset_top = 0
	hud.offset_right = 0
	hud.offset_bottom = 0
	add_child(hud)

	var hud_box := VBoxContainer.new()
	hud_box.set_anchors_preset(Control.PRESET_TOP_WIDE)
	hud.add_child(hud_box)

	exp_progress_bar = ProgressBar.new()
	exp_progress_bar.show_percentage = false
	exp_progress_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	exp_progress_bar.min_value = 0
	exp_progress_bar.max_value = 1
	exp_progress_bar.custom_minimum_size = Vector2(260, 20)
	exp_progress_bar.add_theme_stylebox_override("background", _make_progress_background_style())
	exp_progress_bar.add_theme_stylebox_override("fill", _make_progress_fill_style())
	hud_box.add_child(exp_progress_bar)
	
	var top_row := HBoxContainer.new()
	top_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hud_box.add_child(top_row)
	
	var left_spacer := Control.new()
	left_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_row.add_child(left_spacer)
	
	time_label = Label.new()
	time_label.name = "TimeLabel"
	time_label.text = "0:00"
	time_label.add_theme_font_override("font", UI_FONT)
	time_label.add_theme_font_size_override("font_size", 30)
	time_label.set_anchors_preset(Control.PRESET_CENTER)
	time_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	time_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	top_row.add_child(time_label)
	
	var right_spacer := Control.new()
	right_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_row.add_child(right_spacer)
	
	var kills_box := HBoxContainer.new()
	kills_box.alignment = BoxContainer.ALIGNMENT_CENTER
	top_row.add_child(kills_box)

	kills_label = Label.new()
	kills_label.text = "0"
	kills_label.add_theme_font_override("font", UI_FONT)
	kills_label.add_theme_font_size_override("font_size", 30)
	kills_box.add_child(kills_label)

	var skull := TextureRect.new()
	skull.texture = preload("res://assets/ui/skull.png")
	skull.custom_minimum_size = Vector2(24, 24)
	kills_box.add_child(skull)

func _on_player_exp_gained(_amount: int):
	_refresh_exp_bar()

func _on_upgrade_applied(_upgrade: Dictionary):
	_refresh_exp_bar()

func _refresh_exp_bar():
	var needed: int = leveling._required_blood(leveling.player_level + 1)
	exp_progress_bar.max_value = needed
	exp_progress_bar.value = min(leveling.blood_exp, needed)

func _make_progress_background_style() -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.09, 0.03, 0.03, 0.88)
	sb.border_color = Color(0.09, 0.03, 0.03, 0.88)
	sb.border_width_left = 2; sb.border_width_top = 2
	sb.border_width_right = 2; sb.border_width_bottom = 2
	return sb

func _make_progress_fill_style() -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.84, 0.16, 0.12, 1.0)
	return sb

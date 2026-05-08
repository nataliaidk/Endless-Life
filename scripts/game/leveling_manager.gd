extends Node

signal level_up_ready(choices: Array[Dictionary])
signal upgrade_applied(upgrade: Dictionary)

@export var item_pool: Array[ItemData] = []

@onready var player = get_parent()
@onready var weapon_manager = player.get_node("WeaponManager")

const MAX_ITEMS := 6
const OWNED_WEIGHT := 3

var blood_exp := 0
var player_level := 1
var item_levels: Dictionary = {}
var _pending_requirement := 0
var _in_progress := false

func _ready():
	player.exp_gained.connect(_on_exp_gained)
	for item in item_pool:
		item_levels[item] = 0

func _on_exp_gained(amount: int):
	blood_exp += amount
	_try_trigger_level_up()

func _try_trigger_level_up():
	if _in_progress or player.is_dead:
		return
	var requirement := _required_blood(player_level + 1)
	if blood_exp < requirement:
		return
	var choices := _roll_choices()
	_pending_requirement = requirement
	_in_progress = true
	if choices.is_empty():
		_finish_level_up({})
	level_up_ready.emit(choices)

func on_upgrade_chosen(choice_index: int, choices: Array[Dictionary]):
	if choice_index >= 0 and choice_index < choices.size():
		var chosen := choices[choice_index]
		_apply_choice(chosen)
		_finish_level_up(chosen)
	else:
		_finish_level_up({})

func _apply_choice(choice: Dictionary):
	var item: ItemData = choice.get("item", null)
	if item == null:
		return
	var current_level: int = item_levels.get(item, 0)
	var next_level := current_level + 1
	item_levels[item] = next_level
	if current_level == 0:
		weapon_manager.add_item(item)
	var bonus: ItemLevelData = item.bonuses[next_level - 1]
	player.apply_bonus(bonus)
	
func _finish_level_up(choice: Dictionary):
	blood_exp = max(0, blood_exp - _pending_requirement)
	player_level += 1
	_pending_requirement = 0
	_in_progress = false
	upgrade_applied.emit(choice)
	_try_trigger_level_up()

func _roll_choices() -> Array[Dictionary]:
	var owned: Array[ItemData] = []
	var new_items: Array[ItemData] = []
	
	var slots_used := 0
	for item in item_pool:
		var level: int = item_levels.get(item, 0)
		if level > 0:
			slots_used += 1
		if level >= item.max_level:
			continue
		if level > 0:
			owned.append(item)
		else:
			new_items.append(item)
	
	var slots_full := slots_used >= MAX_ITEMS
	
	var weighted: Array[ItemData] = []
	for item in owned:
		for _i in range(OWNED_WEIGHT):
			weighted.append(item)
	if not slots_full:
		weighted.append_array(new_items)
	
	if weighted.is_empty():
		return []
	
	weighted.shuffle()
	
	var seen: Array[ItemData] = []
	var result: Array[Dictionary] = []
	for item in weighted:
		if item in seen:
			continue
		seen.append(item)
		var current_level: int = item_levels.get(item, 0)
		var next_level := current_level + 1
		if item.bonuses.is_empty() or next_level > item.bonuses.size():
			continue
		result.append({
			"type": "item",
			"item": item,
			"name": item.name,
			"level": next_level,
			"icon": item.icon,
			"bonus_preview": item.bonuses[next_level - 1],
			"is_new": current_level == 0,
		})
		if result.size() >= 3:
			break
	
	if result.size() < 3 and not result.is_empty():
		var original := result.duplicate()
		while result.size() < 3:
			result.append_array(original)
		result.resize(3)
	
	return result

func _required_blood(target_level: int) -> int:
	return max(1, target_level * 2 - 1)

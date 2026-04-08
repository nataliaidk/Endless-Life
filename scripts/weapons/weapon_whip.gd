class_name WeaponWhip
extends BaseWeapon

@export var slash_scene: PackedScene

func _do_attack() -> void:
	var dir = player.facing_direction
	var dir_x = 1
	if dir.x < 0:
		dir_x = -1
	var angle = 0
	if dir_x < 0:
		angle = PI
	var slash = slash_scene.instantiate()
	slash.damage = data.damage
	slash.global_position = player.global_position + Vector2(dir_x, 0) * 30.0
	slash.rotation = angle
	get_tree().current_scene.add_child(slash)

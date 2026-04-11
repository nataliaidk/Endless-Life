extends Area2D
var damage: int = 0

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	$AnimationPlayer.play("attack")
	await $AnimationPlayer.animation_finished
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		var attack = Attack.new()
		attack.damage = damage
		area.get_parent().take_damage(attack)

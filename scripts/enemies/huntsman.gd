extends BaseEnemy

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	xp_gem_table = [
		[XpGem.Type.NONE,   0],
		[XpGem.Type.SMALL,  95],
		[XpGem.Type.MEDIUM, 5],
		[XpGem.Type.LARGE,  0],
	]
	speed      = 75.0
	max_health = 100
	damage     = 25
	super()

func _update_animation(dir: Vector2) -> void:
	if abs(dir.x) > abs(dir.y):
		sprite.play("walk_right" if dir.x > 0 else "walk_left")
	else:
		sprite.play("walk_down" if dir.y > 0 else "walk_up")

func flash_red():
	sprite.modulate = Color(1, 0.3, 0.3)
	await get_tree().create_timer(0.2).timeout
	sprite.modulate = Color(1, 1, 1) 

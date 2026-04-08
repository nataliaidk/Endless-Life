extends BaseEnemy

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	speed      = 75.0
	max_health = 100
	damage     = 25
	super()

func _setup_visuals() -> void:
	pass

func _update_animation(dir: Vector2) -> void:
	if abs(dir.x) > abs(dir.y):
		sprite.play("walk_right" if dir.x > 0 else "walk_left")
	else:
		sprite.play("walk_down" if dir.y > 0 else "walk_up")

func _on_death_effects() -> void:
	sprite.play("die")
	await sprite.animation_finished
	queue_free()

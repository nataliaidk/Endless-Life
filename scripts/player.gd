extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var camera := $Camera2D
@onready var progress_bar: ProgressBar = $ProgressBar

var speed := 200.0
var max_health := 100
var health := 100
var is_dead := false

func _ready():
	camera.make_current()

func _physics_process(_delta):
	if is_dead:
		return
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	move_and_slide()
	update_animation(direction)

func update_animation(direction: Vector2):
	if direction == Vector2.ZERO:
		sprite.play("idle")
	else:
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				sprite.play("walk_right")
			else:
				sprite.play("walk_left")
		else:
			if direction.y > 0:
				sprite.play("walk_down")
			else:
				sprite.play("walk_up")

func take_damage(amount: int):
	if is_dead:
		return
	progress_bar.value = health
	health -= amount
	if health <= 0:
		die()
		
func die():
	is_dead = true
	velocity = Vector2.ZERO
	sprite.play("die")

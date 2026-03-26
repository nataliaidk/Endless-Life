extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var progress_bar: ProgressBar = $ProgressBar

var speed := 75
var max_health := 10
var damage := 5
var health := max_health
var is_dead := false

func _physics_process(_delta):
	if is_dead or player == null:
		return
		
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()
	update_animation(direction)

func update_animation(direction: Vector2):
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
			
func _on_hitbox_body_entered(body):
	if is_dead:
		return
	if body.is_in_group("player"):
		print("damage dealt")
		body.take_damage(damage)

func take_damage(amount: int):
	if is_dead:
		return
	health -= amount
	progress_bar.value = health
	if health <= 0:
		die()

func die():
	is_dead = true
	velocity = Vector2.ZERO
	sprite.play("die")
	queue_free()

extends CharacterBody2D

class_name Enemy

@export var max_health := 10
@export var speed := 100
@export var damage := 1
@export var enemy_sprite: Sprite2D
@export var player = null

var health := max_health

func _ready():
	player = get_tree().get_first_node_in_group("player")
	health = max_health
	if enemy_sprite:
		add_child(enemy_sprite)

func take_damage(amount: int):
	health -= amount
	$ProgressBar.value = health
	if health <= 0:
		die()

func die():
	queue_free()

func _physics_process(_delta):
	if player:
		var direction = global_position.direction_to(player.global_position)
		velocity = direction * speed
		move_and_slide()

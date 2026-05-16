extends Node

var current_gold: int = 0
var current_kills: int = 0

func reset_state():
	current_gold = 0
	current_kills = 0

func add_gold(amount: int):
	current_gold += amount
	
func add_kill():
	current_kills += 1

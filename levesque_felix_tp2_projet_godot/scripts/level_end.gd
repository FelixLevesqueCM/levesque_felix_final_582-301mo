extends Area2D

@onready var game_manager: Node = %GameManager



func _on_body_entered(_body):
	game_manager.change_level()

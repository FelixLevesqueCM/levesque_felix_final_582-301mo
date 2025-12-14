extends Node

@onready var score: Control = $"../CanvasLayer/Control/VBoxContainer/Score/Label"

func _ready():
	score.text = str(GameState.score_count)
	GameState.key = false

func add_point():
	GameState.score_count += 1
	print(GameState.score_count)
	score.text = str(GameState.score_count)

func pickup_key():
	GameState.key = true

func change_level():
	if GameState.key == true:
		GameState.key = false
		GameState.level += 1
		if GameState.level == 1:
			get_tree().change_scene_to_file("res://scenes/Level2.tscn")
		elif GameState.level == 2:
			get_tree().change_scene_to_file("res://scenes/Level3.tscn")
		elif GameState.level == 3:
			get_tree().change_scene_to_file("res://scenes/Level4.tscn")
		elif GameState.level == 4:
			get_tree().change_scene_to_file("res://scenes/Level5.tscn")

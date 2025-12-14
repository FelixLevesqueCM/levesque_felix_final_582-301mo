extends Area2D

@onready var audio_win: AudioStreamPlayer2D = $audio_win
@onready var audio_lose: AudioStreamPlayer2D = $audio_lose
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var label_win: Label = $Label_win
@onready var label_lose: Label = $Label_lose

var idle = true

func _on_body_entered(body: Node2D) -> void:
	if idle == true:
		if GameState.score_count > 45:
			audio_win.play()
			animated_sprite_2d.play("win")
			label_win.show()
		elif GameState.score_count <= 45:
			audio_lose.play()
			animated_sprite_2d.play("lose")
			label_lose.show()
	idle = false

extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cooldown: Timer = $cooldown

func _on_body_entered(_body):
	animation_player.play("pickup")
	GameState.soul_jump = true
	cooldown.start()



func _on_cooldown_timeout():
	animation_player.play("RESET")

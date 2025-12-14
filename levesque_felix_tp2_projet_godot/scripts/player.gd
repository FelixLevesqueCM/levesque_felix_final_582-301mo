extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const AIR_SPEED = 120.0
const ROLL_SPEED = 110.0


var air_friction = 0.9
var roll_direction
var death_direction
var rolling = false
var can_roll = true

@onready var death_timer: Timer = $death_timer

@onready var audio_step: AudioStreamPlayer2D = $Audio_step
@onready var audio_roll: AudioStreamPlayer2D = $Audio_roll
@onready var audio_jump: AudioStreamPlayer2D = $Audio_jump
@onready var audio_death: AudioStreamPlayer2D = $Audio_death

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var roll_timer: Timer = $roll_timer
@onready var roll_colldown: Timer = $roll_colldown

func _physics_process(delta):
	
	#appliquer la gravité
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	#détecter le saut si le joueur est au sol et n'est pas en train de faire une roullade
	if Input.is_action_just_pressed("jump") and is_on_floor() and !rolling and GameState.alive == true or GameState.soul_jump == true and GameState.alive == true:
		velocity.y = JUMP_VELOCITY
		audio_jump.play()
		GameState.soul_jump = false
	
	#détecter la direction
	var direction := Input.get_axis("move_left", "move_right")
	
	#détecter la roullade si le joueur est au sol, est en train de bouger dans une direction et a le droit de rouller
	if Input.is_action_just_pressed("roll") and is_on_floor() and can_roll and direction != 0 and GameState.alive == true:
		audio_roll.play()
		#enregister la direction de la roullade
		if can_roll:
			roll_direction = direction
		rolling = true
		#empêcher de faire une autre roullade
		can_roll = false
		#rendre le joueur invulnérable
		set_collision_layer_value(3, false)
		roll_timer.start()
		roll_colldown.start()
	
	# empècher l'animation de changer de direction lors d'une roullade ou de l'animation de mort
	if rolling == true:
		if roll_direction > 0:
			animated_sprite.flip_h = false
		elif roll_direction < 0:
			animated_sprite.flip_h = true
	elif rolling == false:
		if direction > 0:
			animated_sprite.flip_h = false
		elif direction < 0:
			animated_sprite.flip_h = true
		
	
	#appliquer les animations
	if GameState.alive == true:
		if is_on_floor(): 
			if rolling == true:
				animated_sprite.play("roll")
			elif direction == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")
		else:
			animated_sprite.play("jump")
	else:
		animated_sprite.play("death")
	
	#appliquer la vitesse appropriée à l'action du joueur
	if GameState.alive == true:
		#vitetesse roullade
		if rolling:
			velocity.x = roll_direction * ROLL_SPEED
		#vitesse au sol
		elif direction and is_on_floor():
			velocity.x = direction * SPEED
		# vitesse en l'air avec un direction
		elif direction and !is_on_floor():
			velocity.x = direction * AIR_SPEED
		#ralentir graduellement en l'air lorsqu'il n'y a pas de direction
		elif !is_on_floor():
			velocity.x = velocity.x * air_friction
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	elif GameState.alive == false:
		velocity.x = 0
	
	if direction and is_on_floor():
		if !audio_step.playing and !rolling:
			audio_step.play()
	
	if GameState.alive == false and GameState.dying == true:
		GameState.dying = false
		death_direction = direction
		death()
	
	move_and_slide()

#sortir de l'état de roullade
func _on_roll_timer_timeout() -> void:
	rolling = false
	set_collision_layer_value(3, true)

#cooldown pour la roullade
func _on_roll_colldown_timeout() -> void:
	can_roll = true

func death():
	audio_death.play()
	death_timer.start()
	set_collision_layer_value(3, false)


func _on_death_timer_timeout() -> void:
	set_collision_layer_value(3, true)

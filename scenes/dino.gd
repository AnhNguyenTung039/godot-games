extends CharacterBody2D

const GRAVITY : int = 4200
const JUMP_SPEED : int = -1800

# Called every frame, 'delta' is elapsed time since the previous frame
func _physics_process(delta):
	velocity.y += GRAVITY * delta
	if is_on_floor():
		$RunningCollision.disabled = false
		
		if Input.is_action_pressed("ui_accept") || Input.is_action_pressed("ui_up"):
			velocity.y = JUMP_SPEED
			$JumpSound.play()
		elif Input.is_action_pressed("ui_down"):
			$AnimatedSprite2D.play("duck")
			$RunningCollision.disabled = true
		else:
			$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("jump")
		
	move_and_slide()

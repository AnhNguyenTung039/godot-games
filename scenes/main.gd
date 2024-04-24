extends Node

# Game variables
const DINO_START_POSITION := Vector2i(150, 485)
const CAMERA_START_POSITION := Vector2i(576, 324)

var score : int

var speed : float
const START_SPEED : float = 10.0
const MAX_SPEED : int = 25

var screen_size : Vector2i

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_window().size
	new_game()


func new_game ():
	# Reset variables
	score = 0
	
	# Reset the nodes
	$Dino.position = DINO_START_POSITION
	$Dino.velocity = Vector2i(0, 0)
	
	$Camera2D.position = CAMERA_START_POSITION
	
	$Ground.position = Vector2i(0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	speed = START_SPEED
	
	# Move the Dino and Camera position
	$Dino.position.x += speed
	$Camera2D.position.x += speed
	
	# Update score
	score += speed / 10
	# Can't devided to 100 cause it will cause 
	print(score)
	
	# Update the ground position
	if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
		$Ground.position.x += screen_size.x # Move the ground along by the width of the screen # HOW?

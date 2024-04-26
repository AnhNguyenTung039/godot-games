extends Node

# Game variables
const DINO_START_POSITION := Vector2i(150, 485)
const CAMERA_START_POSITION := Vector2i(576, 324)

var score : int
const SCORE_MODIFIER : int = 10

var speed : float
const START_SPEED : float = 10.0
const MAX_SPEED : int = 25

var screen_size : Vector2i

var game_running : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_window().size
	new_game()


func new_game ():
	# Reset variables
	score = 0
	show_score()
	
	# Reset the nodes
	$Dino.position = DINO_START_POSITION
	$Dino.velocity = Vector2i(0, 0)
	
	$Camera2D.position = CAMERA_START_POSITION
	
	$Ground.position = Vector2i(0, 0)
	
	# Shot start label
	$HUD.get_node("StartLabel").show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_running: 
		speed = START_SPEED
		
		# Move the Dino and Camera position
		$Dino.position.x += speed
		$Camera2D.position.x += speed
		
		# Update score
		score += speed
		show_score()
		
		# Update the ground position
		if $Camera2D.position.x - $Ground.position.x > screen_size.x * 1.5:
			$Ground.position.x += screen_size.x # Move the ground along by the width of the screen # HOW?
	else:
		if Input.is_action_just_pressed("ui_accept"):
			game_running = true
			$HUD.get_node("StartLabel").hide()

func show_score():
	$HUD.get_node("ScoreLabel").text = "SCORE: " + str(score / SCORE_MODIFIER)

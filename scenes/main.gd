extends Node

# Preload obstacles
var stump_scene = preload("res://stump.tscn")
var rock_scene = preload("res://rock.tscn")
var barrel_scene = preload("res://barrel.tscn")
var bird_scene = preload("res://bird.tscn")
var obstacle_types := [stump_scene, rock_scene, barrel_scene]
var obstacles : Array
var bird_heights := [200, 390]

# Game variables
const DINO_START_POSITION := Vector2i(150, 485)
const CAMERA_START_POSITION := Vector2i(576, 324)

var difficulty
const MAX_DIFFICULTY : int = 2

var score : int
const SCORE_MODIFIER : int = 10

var speed : float
const START_SPEED : float = 10.0
const MAX_SPEED : int = 25
var SPEED_MODIFIER : int = 5000

var screen_size : Vector2i
var ground_height : int

var game_running : bool

var last_obstacle

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_window().size
	ground_height = $Ground.get_node("Sprite2D").texture.get_height()
	new_game()

func new_game ():
	# Reset variables
	score = 0
	show_score()
	game_running = false
	difficulty = 0
	
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
		# Speed up and adjust difficulty
		speed = START_SPEED + score / SPEED_MODIFIER
		
		if speed > MAX_SPEED:
			speed = MAX_SPEED
		
		adjust_difficulty()
		
		# Generate obstacles
		generate_obstacle()
		
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

func generate_obstacle():
	# Generate ground obstacles
	if obstacles.is_empty() or last_obstacle.position.x < score + randi_range(300, 500):
		var obstacle_type = obstacle_types[randi() % obstacle_types.size()]
		var obstacle
		
		var max_obstacles = difficulty + 1
		for i in range(randi() % max_obstacles + 1):
			obstacle = obstacle_type.instantiate()
			var obstacle_height = obstacle.get_node("Sprite2D").texture.get_height()
			var obstacle_scale = obstacle.get_node("Sprite2D").scale
			var obstacle_x : int = screen_size.x + score + 100 + (i * 100)
			var obstacle_y : int = screen_size.y - ground_height - (obstacle_height * obstacle_scale.y / 2) + 5
			last_obstacle = obstacle
			add_obstacle(obstacle, obstacle_x, obstacle_y)

func add_obstacle(obstacle, x, y):
	obstacle.position = Vector2i(x, y)
	add_child(obstacle) # Add obstacle as a child of the current node which is main scene
	obstacles.append(obstacle) # Add obstacle to the obstacles array

func adjust_difficulty():
	difficulty = score / SPEED_MODIFIER
	if difficulty > MAX_DIFFICULTY:
		difficulty = MAX_DIFFICULTY

extends Node

export (PackedScene) var Enemy

# Declare member variables here. Examples:
var score
var high_score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

func game_over():
	$Music.stop()
	$ScoreTimer.stop()
	$EnemyTimer.stop()
	$HUD.show_game_over()
	$DeathSound.play()			
	$HUD.update_high_score(score)
	
func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!!!!")
	$Music.play()

func _on_EnemyTimer_timeout():
	$EnemyPath/EnemySpawnLocation.set_offset(randi())
	var enemy_spawn = Enemy.instance()
	add_child(enemy_spawn)
	var direction = $EnemyPath/EnemySpawnLocation.rotation + PI / 2
	enemy_spawn.position = $EnemyPath/EnemySpawnLocation.position
	
	direction += rand_range(-PI / 4, PI / 4)
	enemy_spawn.rotation = direction
	enemy_spawn.linear_velocity = Vector2(rand_range(enemy_spawn.min_speed, enemy_spawn.max_speed), 0)
	enemy_spawn.linear_velocity = enemy_spawn.linear_velocity.rotated(direction)
	
	$HUD.connect("start_game", enemy_spawn, "_on_start_game")

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_StartTimer_timeout():
	$EnemyTimer.start()
	$ScoreTimer.start()


extends Node

export (PackedScene) var Enemy
export (PackedScene) var PowerUp
 
# Declare member variables here. Examples:
var score = 0
var active_power_up

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$HUD.get_high_score_from_save_file()

func game_over():
	if(active_power_up != null):
		destroy_power_up()
	$Music.stop()
	$DeathSound.play()
	$ScoreTimer.stop()
	$EnemyTimer.stop()
	$PowerUpTimer.stop()
	$HUD.show_game_over()
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

# warning-ignore:return_value_discarded
	$HUD.connect("start_game", enemy_spawn, "_on_start_game")

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_StartTimer_timeout():
	$EnemyTimer.start()
	$ScoreTimer.start()
	$PowerUpTimer.start()

func _on_PowerUpTimer_timeout():
	if(active_power_up != null):
		destroy_power_up()
		
	var power_up = PowerUp.instance()
	active_power_up = power_up
	add_child(power_up)
	power_up.position.x = randi() % 480
	power_up.position.y = randi() % 720

func power_up_score():
	print("Adding power up score")
	if score != 0:
		score += 5
	$HUD.update_score(score)
	
func destroy_power_up():
	active_power_up.queue_free()
	active_power_up = null
		
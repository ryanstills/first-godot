extends RigidBody2D

# Declare member variables here. Examples:
export var min_speed = 150
export var max_speed = 250
var enemy_types = ["walk", "swim", "fly"]


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.animation = enemy_types[randi() % enemy_types.size()]

func _on_Visibility_screen_exited():
	queue_free()
	
func _on_start_game():
	queue_free()

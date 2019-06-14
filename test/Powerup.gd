extends Area2D

func _ready():
	$LifeTimer.start()
	
func _on_PowerUp_area_entered(area):
	print("Power Up picked up")
	get_parent().power_up_score()
	queue_free()


func _on_LifeTimer_timeout():
	get_parent().destroy_power_up()

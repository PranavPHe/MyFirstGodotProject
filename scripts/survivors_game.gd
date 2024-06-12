extends Node2D

var spawn_interval = 1.0

func _ready():
	$Timer.wait_time = spawn_interval

func spawn_mob():
	#Mobs will spawn at a random location
	var new_mob = preload("res://scenes/mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)

#Have mobs spawn every once in a while
func _on_timer_timeout():
	%TimeCycle.text = "Nighttime"
	spawn_mob()

func _on_player_health_depleted():
	%GameOver.visible = true
	get_tree().paused = true

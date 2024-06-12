extends Area2D

var travelled_distance = 0

func _physics_process(delta):
	const SPEED = 600
	const RANGE = 1200
	var direction = Vector2.RIGHT.rotated(rotation)
	
	# Setting the speed of the bullet, and setting range
	position += direction * SPEED * delta
	travelled_distance += SPEED * delta
	if travelled_distance > RANGE:
		queue_free()


func _on_body_entered(body):
	#Destroying the bullet
	queue_free()
	
	#Check if the body touched has a function called take_damage
	if body.has_method("take_damage"):
		body.take_damage()

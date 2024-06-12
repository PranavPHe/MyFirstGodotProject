extends CharacterBody2D

signal health_depleted
var health = 100.0
	
#Define Physics Process function
func _physics_process(delta):
	#Take in the user input and find the direction
	var direction = Input.get_vector("move_left", "move_right", 
	"move_up", "move_down")
	# Giving the character a speed to move at
	velocity = direction * 600
	move_and_slide()
	
	#Giving the sprite an animation
	if velocity.length() > 0.0:
		$HappyBoo.play_walk_animation()
	else:
		$HappyBoo.play_idle_animation()
	
	#Health control for the player
	const DAMAGE_RATE = 5.0
	var overlapping_mobs = %HurtBox.get_overlapping_bodies()
	if overlapping_mobs.size() > 0:
		health -= DAMAGE_RATE * overlapping_mobs.size() * delta
		%ProgressBar.value = health
		%ProgressBar.max_value = 100
		if health <= 0.0:
			health_depleted.emit()

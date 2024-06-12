extends CharacterBody2D

var health = 4
@onready var player = get_node("/root/Game/Player")

func _ready():
	%Slime.play_walk()

func _physics_process(delta):
	#Get the direction to the player
	var direction = global_position.direction_to(player.global_position)
	#Mob moves toward player
	velocity = direction * 300.0
	move_and_slide()

func take_damage():
	health -= 1
	%Slime.play_hurt()
	if health == 0:
		queue_free()

		#When the Mob dies, have a smoke effect
		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position

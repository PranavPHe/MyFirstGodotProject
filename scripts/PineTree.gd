extends Node2D

var tree_texture
const TREE_SIZE = 16
const TREE_CHANCE = 0.005  # Decreased tree chance
const CHUNK_SIZE = 75  # Increased chunk size
const MAP_SIZE = 200  # Total number of grid cells along one axis

var chunks = {}  # Dictionary to store generated chunks
var noise  # Reuse the same noise instance for all chunks

func _ready():
	tree_texture = load("res://trees/pine_tree.png")
	noise = FastNoiseLite.new()
	noise.seed = randi()
	noise.set_noise_type(FastNoiseLite.TYPE_SIMPLEX)
	noise.set_fractal_type(FastNoiseLite.FRACTAL_FBM)
	noise.set_fractal_octaves(4)

func _process(delta):
	var player_pos = get_global_mouse_position()  # Replace with your player's position
	var chunk_x = floor(player_pos.x / (CHUNK_SIZE * TREE_SIZE))
	var chunk_y = floor(player_pos.y / (CHUNK_SIZE * TREE_SIZE))
	
	if not chunks.has(Vector2(chunk_x, chunk_y)):
		generate_chunk(chunk_x, chunk_y)

func generate_chunk(chunk_x, chunk_y):
	var tree_count = 0
	for x in range(chunk_x * CHUNK_SIZE, (chunk_x + 1) * CHUNK_SIZE):
		for y in range(chunk_y * CHUNK_SIZE, (chunk_y + 1) * CHUNK_SIZE):
			var tree_pos = Vector2(x * TREE_SIZE, y * TREE_SIZE)
			var noise_value = noise.get_noise_2d(float(x) / 20.0, float(y) / 20.0)
			if noise_value > 0 and randf() < TREE_CHANCE:
				tree_pos += Vector2(randf() * TREE_SIZE - TREE_SIZE / 2, randf() * TREE_SIZE - TREE_SIZE / 2)
				var tree = Sprite2D.new()
				tree.texture = tree_texture
				tree.position = tree_pos
				
				# Add a CollisionShape2D to the tree
				var collision_shape = CollisionShape2D.new()
				collision_shape.shape = RectangleShape2D.new()
				collision_shape.shape.extents = Vector2(TREE_SIZE / 2, TREE_SIZE / 2)
				tree.add_child(collision_shape)
				
				add_child(tree)
				tree_count += 1
	
	chunks[Vector2(chunk_x, chunk_y)] = true
	print("Generated trees in chunk (", chunk_x, ", ", chunk_y, "): ", tree_count)

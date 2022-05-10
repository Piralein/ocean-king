extends Control

# ====================
# Reference
# ====================

var bottle = preload("res://Scene/Prefab/Bottle/Bottle.tscn")

# ====================
# Variables
# ====================

var started: bool = false
export var speed = 200
var game_rect_size
var rng = RandomNumberGenerator.new()
var bottles_evaded: int
var defense: int

var colors = [
	Color(1.0, 0.0, 0.0, 1.0),
	Color(1.0, 1.0, 0.0, 1.0),
	Color(0.0, 1.0, 0.0, 1.0),
	Color(1.0, 0.0, 1.0, 1.0),
	Color(0.0, 0.0, 1.0, 1.0),
	Color(1.0, 1.0, 1.0, 1.0),
	Color(0.0, 1.0, 1.0, 1.0),
]

func _ready():
	rng.randomize()
	Signal.connect("evaded", self, "evaded")

# ====================
# Start Minigame
# ====================

func start():
	bottles_evaded = 0
	defense = 0
	$Evaded/Layout/Amount.text = "0"
	$Defense/Layout/Amount.text = "0"
	started = true
	visible = true
	game_rect_size = $Container.get_global_rect()
	$Player.position.x = game_rect_size.position.x + 16
	$Player/Sprite.flip_h = false
	spawn()

# ====================
# End Minigame
# ====================

func stop():
	started = false
	visible = false
	$Timer.stop()
	for n in $Container.get_children():
		n.bottle_disabled = true
		n.visible = false
		n.queue_free()

# ====================
# Play Minigame
# ====================

func _process(delta):
	if(started):
		var velocity = Vector2()  # The player's movement vector.
		if Input.is_key_pressed(KEY_D):
			velocity.x += 1
			$Player/Sprite.flip_h = false
		elif Input.is_key_pressed(KEY_A):
			velocity.x -= 1
			$Player/Sprite.flip_h = true
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
		$Player.position += velocity * delta
		$Player.position.x = clamp($Player.position.x, game_rect_size.position.x + 16, game_rect_size.size.x + game_rect_size.position.x - 16)

# ====================
# Spawn Bottles
# ====================

func spawn():
	var position_x = rng.randf_range(game_rect_size.position.x + 16, game_rect_size.size.x + game_rect_size.position.x - 16)
	var instance = bottle.instance()
	instance.position = Vector2(position_x, game_rect_size.position.y)
	instance.setColor(colors[randi() % colors.size()])
	$Container.add_child(instance)
	$Timer.start()

# ====================
# Play Minigame
# ====================
func _on_Player_body_entered(body):
	$Timer.stop()
	bottles_evaded = 0
	$Evaded/Layout/Amount.text = "0"
	$Player.position.x = game_rect_size.position.x + 16
	$Player/Sprite.flip_h = false
	for n in $Container.get_children():
		n.bottle_disabled = true
		n.visible = false
		n.queue_free()
	$Timer.start()

func _on_Timer_timeout():
	if(started):
		spawn()

func evaded():
	bottles_evaded += 1
	$Evaded/Layout/Amount.text = String(bottles_evaded)
	
	if(bottles_evaded >= 20):
		Signal.emit_signal("addDefense")
		defense += 1
		$Defense/Layout/Amount.text = String(defense)
		bottles_evaded -= 20

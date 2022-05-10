extends Control

# ====================
# Reference
# ====================

var worm = preload("res://Scene/Prefab/Worm/Worm.tscn")

# ====================
# Variables
# ====================

var catched: int
var rng = RandomNumberGenerator.new()
var current_time
var started: bool = false

# ====================
# Setup
# ====================

func _ready():
	rng.randomize()
	Signal.connect("catched", self, "onCatched")

# ====================
# Start Minigame
# ====================

func start():
	catched = 0
	current_time = 4.0
	$Catched/Layout/Amount.text = String(catched)
	visible = true
	$BackButton.grab_focus()
	started = true

# ====================
# End Minigame
# ====================

func stop():
	started = false
	visible = false
	for n in $Sand.get_children():
		n.queue_free()

# ====================
# Spawn Timer
# ====================

func _process(delta):
	if(started):
		current_time += delta
		if(current_time >= 6.0):
			current_time = 0.0
			spawn()

# ====================
# Spawn
# ====================

func spawn():
	var rect = $Sand.get_global_rect()
	for n in range(0,6):
		var position_x = rng.randf_range(rect.position.x + 32, rect.size.x - 32)
		var position_y = rng.randf_range(rect.position.y + 32, rect.size.y - 32)
		var instance = worm.instance()
		instance.rect_position = Vector2(position_x, position_y)
		$Sand.add_child(instance)
		instance.rect_size = Vector2(32,32)

# ====================
# Catched
# ====================

func onCatched():
	Signal.emit_signal("addHitpoints")
	catched += 1
	$Catched/Layout/Amount.text = String(catched)

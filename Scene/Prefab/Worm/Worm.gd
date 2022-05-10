extends Control

# ====================
# Variables
# ====================

var rng = RandomNumberGenerator.new()
var catchable: bool = false
var alive: int

# ====================
# Setup
# ====================

func _ready():
	rng.randomize()
	alive = rng.randi_range(1, 20)
	print(alive)
	$Timer.wait_time = rng.randi_range(2, 4)
	$Timer.start()

# ====================
# Setup
# ====================

func timeout():
	if(catchable):
		visible = false
		queue_free()
	else:
		if(alive <= 10):
			catchable = true
			$CatchSprite.visible = true
			$Animation.visible = false
			$Timer.wait_time = 1
			$Timer.start()
		else:
			visible = false
			queue_free()

# ====================
# Pressed Worm
# ====================

func pressed():
	if(catchable):
		Signal.emit_signal("catched")
	visible = false
	queue_free()

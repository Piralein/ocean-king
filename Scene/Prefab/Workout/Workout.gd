extends Control

# ====================
# Variables
# ====================

var rng = RandomNumberGenerator.new()
var started: bool = false
var current_key
var current_time: float
var streak: int
var total_attack: int

var keys: Dictionary = {
	"A": KEY_A,
	"W": KEY_W,
	"S": KEY_S,
	"D": KEY_D
}

# ====================
# Setup
# ====================

func _ready():
	rng.randomize()

# ====================
# Start Minigame
# ====================

func start():
	$BackButton.grab_focus()
	resetStreak()
	$Total/Layout/Amount.text = "0"
	started = true
	visible = true
	getRandomKey()

# ====================
# End Minigame
# ====================

func stop():
	started = false
	visible = false
	total_attack = 0
	current_time = 0.0

# ====================
# Get Random Key
# ====================

func getRandomKey():
	var random_id = rng.randi() % keys.size()
	var random_key = keys.keys()[random_id]
	$Key_Container/Key.text = random_key
	current_key = keys.get(random_key)

# ====================
# Check Keys
# ====================

func _unhandled_key_input(event):
	if(started):
		if event.pressed:
			if event.scancode == current_key:
				current_time = 0.0
				addStreak()
				getRandomKey()
			else:
				current_time = 0.0
				resetStreak()
				getRandomKey()

# ====================
# Reset after time
# ====================

func _process(delta):
	if(started):
		current_time += delta
		if(current_time >= 4.0):
			current_time = 0.0
			resetStreak()
			getRandomKey()

# ====================
# Streak
# ====================

func addStreak():
	streak += 1
	$Streak/Layout/Amount.text = String(streak)
	if(streak % 5 == 0):
		var amount = (floor(streak/25) + 1)
		Signal.emit_signal("addAttack", amount)
		total_attack += amount
		$Total/Layout/Amount.text = String(total_attack)
		$Current/Layout/Amount.text = String(amount)
	
func resetStreak():
	streak = 0
	$Streak/Layout/Amount.text = "0"
	$Current/Layout/Amount.text = "1"

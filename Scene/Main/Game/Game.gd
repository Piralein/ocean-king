extends Node

# ====================
# Setup
# ====================

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	Signal.connect("battle_won", self, "battleWon")
	Signal.connect("muted", self, "mute")
	$StartWorkout.disabled = true
	$StartFishing.disabled = true
	$StartEvade.disabled = true
	$Battle.disableBattle()
	$Intro/Button.grab_focus()
	if(!Settings.muted):
		#$AudioStreamPlayer.play()
		pass

func mute():
	if(Settings.muted):
		$AudioStreamPlayer.stop()
	else:
		#$AudioStreamPlayer.play()
		pass

# ====================
# Handle Minigames
# ====================

func startFishing():
	if(!$Battle.active):
		$Fishing.start()

func startEvade():
	if(!$Battle.active):
		$Evade.start()

func startWorkout():
	if(!$Battle.active):
		$Workout.start()

# ====================
# Handle Decorations
# ====================

func battleWon(id):
	match(id):
		1:
			$Decoration/Seestar.visible = false
			$Decoration/Seestar2.visible = true
		2:
			$Decoration/SeeSerpent.visible = false
			$Decoration/SeeSerpent2.visible = true
		3:
			$Decoration/Seehorse.visible = false
			$Decoration/Seehorse2.visible = true
		4:
			$Decoration/Pufferfish.visible = false
			$Decoration/Pufferfish2.visible = true
		5:
			$Decoration/King.visible = false
			$Decoration/King2.visible = true
			$TimerMessage.stop()
			$Message.visible = false

# ====================
# Handle Intro
# ====================

func intro():
	$Intro.visible = false
	$StartWorkout.disabled = false
	$StartFishing.disabled = false
	$StartEvade.disabled = false
	$Battle.enableBattle()
	$TimerMessage.start()

# ====================
# Open / Close Options
# ====================

func showOptions():
	$Options.visible = true

#func _unhandled_input(event):
#	if event is InputEventKey:
#		if event.pressed and event.scancode == KEY_ESCAPE:
#			if($Options.visible):
#				$Options.visible = false
#			else:
#				$Options.visible = true

# ====================
# Handle Puns
# ====================

var puns = ["something smells fishy!", "This is getting out of sand!", "Sea ya later!", "Don’t shell me what to do!"]
var message_active: bool = false

func message():
	if(message_active):
		$Message.visible = false
		message_active = false
		$TimerMessage.wait_time = rng.randf_range(2, 8)
		$TimerMessage.start()
	else:
		$Message/Label.text = puns[randi() % puns.size()]
		$Message.visible = true
		message_active = true
		$TimerMessage.wait_time = 10.0
		$TimerMessage.start()

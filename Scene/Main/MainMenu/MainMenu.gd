extends Control

# ====================
# Nodes and Resources
# ====================
var game_scene = "res://Scene/Main/Game/Game.tscn"

# ====================
# Setup
# ====================

func _ready():
	$CenterContainer/VBoxContainer/VBoxContainer/StartGame.grab_focus()

# ====================
# Start Game
# ====================
func startGame():
	get_tree().change_scene(game_scene)

# ====================
# Open / Close Options
# ====================

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			if($Options.visible):
				$Options.visible = false
			else:
				$Options.visible = true

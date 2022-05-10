extends Control

# ====================
# Close Options
# ====================

func _ready():
	if(Settings.muted):
		$CheckBox.set_pressed_no_signal(true)

func hideOptions():
	visible = false

func showOptions():
	visible = true
	$BackButton.grab_focus()


func mute(button_pressed):
	Settings.muted = button_pressed
	Signal.emit_signal("muted")

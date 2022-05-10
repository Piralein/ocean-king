extends Control

# ====================
# Mouse Hover Start
# ====================
func mouse_entered():
	grab_focus()
	$Icon.visible = true

# ====================
# Mouse Hover End
# ====================
func mouse_exited():
	if(self != get_focus_owner ()):
		$Icon.visible = false

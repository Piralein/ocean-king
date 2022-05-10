extends Node

# ====================
# Variables
# ====================

var bottle_disabled: bool = false

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	if(!bottle_disabled):
		Signal.emit_signal("evaded")
	queue_free()

func setColor(color):
	$Sprite.modulate = color

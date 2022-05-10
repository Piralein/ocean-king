extends Control
class_name BattleUI

# ====================
# Paths to set
# ====================

export(NodePath) var attack_path
export(NodePath) var defense_path
export(NodePath) var hitpoints_path
export(NodePath) var current_hp_path
export(NodePath) var progress_bar_path
export(NodePath) var avatar_path

# ====================
# References
# ====================

onready var attack = get_node(attack_path)
onready var defense = get_node(defense_path)
onready var hitpoints = get_node(hitpoints_path)
onready var current_hp = get_node(current_hp_path)
onready var progress = get_node(progress_bar_path)
onready var avatar = get_node(avatar_path)

# ====================
# Update UI Part
# ====================

func updateStats(attack_value: String, defense_value: String, hitpoints_value: String):
	attack.text = attack_value
	defense.text = defense_value
	hitpoints.text = hitpoints_value

func updateHp(hitpoints_value: int, increase = false):
	if(increase):
		progress.max_value = hitpoints_value
	progress.value = hitpoints_value
	current_hp.text = String(hitpoints_value)

func updateAvatar(texture: Texture):
	avatar.texture = texture
	

func getAvatar():
	return avatar

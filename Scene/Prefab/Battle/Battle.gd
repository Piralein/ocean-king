extends Control

# ====================
# Values to set
# ====================

export(NodePath) var character_ui_path
export(NodePath) var enemy_ui_path
export(Dictionary) var enemies

export(int) var attack
export(int) var defense
export(int) var hitpoints

# ====================
# Variables
# ====================

onready var character_ui: BattleUI = get_node(character_ui_path)
onready var enemy_ui: BattleUI = get_node(enemy_ui_path)

var current_enemy: EnemyAbstract
var current_enemy_id: int
var current_enemy_hp: int
var current_hp: int
var active: bool = false
var enemy_turn = false

# ====================
# Setup
# ====================

func _ready():
	# Connect Signals
	Signal.connect("addAttack", self, "addAttack")
	Signal.connect("addDefense", self, "addDefense")
	Signal.connect("addHitpoints", self, "addHitpoints")
	
	# Set inital value
	current_hp = hitpoints
	current_enemy = enemies.get(1, EnemyAbstract)
	current_enemy_id = 1
	current_enemy_hp = current_enemy.hitpoints
	
	# Update UI
	reset()

# ====================
# Update Stats
# ====================

func addAttack(amount):
	if(!active):
		attack += amount
		character_ui.updateStats(String(attack), String(defense), String(hitpoints))

func addDefense():
	if(!active):
		defense += 1
		character_ui.updateStats(String(attack), String(defense), String(hitpoints))

func addHitpoints():
	if(!active):
		hitpoints += 5
		current_hp = hitpoints
		character_ui.updateStats(String(attack), String(defense), String(hitpoints))
		character_ui.updateHp(hitpoints, true)

# ====================
# Battle Start
# ====================

func startBattle():
	setBattleActive()
	Signal.emit_signal("battle_started")
	yield(get_tree().create_timer(1.0), "timeout")
	turn()

# ====================
# Battle Stop
# ====================

func stopBattle():
	$Timer.stop()
	setBattleInactive()
	#Signal.emit_signal("battle_stopped")
	reset()

# ====================
# Battle End
# ====================

func endBattle():
	setBattleInactive()
	Signal.emit_signal("battle_ended")
	Signal.emit_signal("battle_won", current_enemy_id)
	if(!current_enemy.is_last):
		current_enemy_id += 1
		current_enemy = enemies.get(current_enemy_id, EnemyAbstract)
		current_enemy_hp = current_enemy.hitpoints
		reset()
	else:
		battleWon()

# ====================
# Battle Turn
# ====================

func turn():
	# Enemy Turn
	if(enemy_turn):
		var hp = current_hp - clamp((current_enemy.attack - defense), 1, 9999)
		if(hp < 0):
			hp = 0
		var position = enemy_ui.getAvatar().rect_position
		enemy_ui.getAvatar().rect_position = Vector2(position.x - 15, position.y)
		if(!Settings.muted):
			$AudioStreamPlayer.play()
		setCurrentHp(hp)
		yield(get_tree().create_timer(0.25), "timeout")
		enemy_ui.getAvatar().rect_position = position
		if(hp > 0):
			enemy_turn = false
			$Timer.start()
		else:
			# Character Died
			reset()
	# Character Turn
	else:
		var hp = current_enemy_hp - clamp((attack - current_enemy.defense), 1, 9999)
		if(hp < 0):
			hp = 0
		var position = character_ui.getAvatar().rect_position
		character_ui.getAvatar().rect_position = Vector2(position.x + 15, position.y)
		if(!Settings.muted):
			$AudioStreamPlayer.play()
		setCurrentEnemyHp(hp)
		yield(get_tree().create_timer(0.25), "timeout")
		character_ui.getAvatar().rect_position = position
		if(hp > 0):
			enemy_turn = true
			$Timer.start()
		else:
			# Enemy Died
			setBattleInactive()
			endBattle()

# ====================
# Battle Won
# ====================

func battleWon():
	setBattleInactive()
	$Layout.visible = false
	$Start.visible = false
	$WinIcon.visible = true
	
# ====================
# Update Current Hp
# ====================

func setCurrentEnemyHp(hp):
	current_enemy_hp = hp
	enemy_ui.updateHp(hp)

func setCurrentHp(hp):
	current_hp = hp
	character_ui.updateHp(hp)

# ====================
# Reset
# ====================

func reset():
	resetCharacter()
	resetEnemy()
	setBattleInactive()

func resetCharacter():
	current_hp = hitpoints
	character_ui.updateStats(String(attack), String(defense), String(hitpoints))
	character_ui.updateHp(hitpoints, true)

func resetEnemy():
	current_enemy_hp = current_enemy.hitpoints
	enemy_ui.updateStats(String(current_enemy.attack), String(current_enemy.defense), String(current_enemy.hitpoints))
	enemy_ui.updateHp(current_enemy.hitpoints, true)
	enemy_ui.updateAvatar(current_enemy.avatar)

# ====================
# Battle Status
# ====================

func setBattleActive():
	active = true
	$Start.visible = false
	$Stop.visible = true
	$BattleIcon.visible = true

func setBattleInactive():
	active = false
	enemy_turn = false
	$Start.visible = true
	$Stop.visible = false
	$BattleIcon.visible = false

# ====================
# Button Status
# ====================

func disableBattle():
	$Start.disabled = true
	$Stop.disabled = true

func enableBattle():
	$Start.disabled = false
	$Stop.disabled = false

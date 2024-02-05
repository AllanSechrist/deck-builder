extends Node2D

@export var char_stats: CharacterStats
@export var music: AudioStream

@onready var battle_ui = $BattleUI as BattleUI
@onready var player_handler: PlayerHandler = $PlayerHandler as PlayerHandler
@onready var enemy_handler: EnemyHandler = $EnemyHandler as EnemyHandler
@onready var player: Player = $Player as Player

func _ready() -> void:
	# This would reset all the players stats inbetween
	# battles. If you want this to persist between battles
	# this code would go at the start of a "Run" of the game.
	var new_stats: CharacterStats = char_stats.create_instance()
	battle_ui.char_stats = new_stats
	player.stats = new_stats
	
	#enemy_handler.child_order_changed.connect(_on_enemy_handler_child_order_changed)
	Events.enemy_turn_ended.connect(_on_enemy_turn_ended)
	
	Events.player_turn_ended.connect(player_handler.end_turn)
	Events.player_hand_discarded.connect(enemy_handler.start_turn)
	
	Events.player_died.connect(_on_player_death)
	start_battle(new_stats)
	
func start_battle(stats: CharacterStats) -> void:
	get_tree().paused = false
	MusicPlayer.play(music, true)
	enemy_handler.reset_enemy_actions()
	player_handler.start_battle(stats)
	
func _on_enemy_turn_ended() -> void:
	player_handler.start_turn()
	enemy_handler.reset_enemy_actions()


func _on_enemy_handler_child_order_changed():
	if enemy_handler.get_child_count() == 0:
		Events.battle_over_screen_requested.emit("Victorious!", BattleOverPanel.Type.WIN)
		
func _on_player_death():
	Events.battle_over_screen_requested.emit("Game Over", BattleOverPanel.Type.LOSE)

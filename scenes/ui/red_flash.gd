extends CanvasLayer
# it is important to remember that the ColorRect -> Mouse -> Filter property
# must be set to Ignore or the ColorRect will "Block" all mouse interactions
# because the ColorRect sits above the BattleUI in the Layer system.
@onready var color_rect: ColorRect = $ColorRect
@onready var timer: Timer = $Timer


func _ready() -> void:
	Events.player_hit.connect(_on_player_hit)
	timer.timeout.connect(_on_timer_timeout)
	
func _on_player_hit() -> void:
	color_rect.color.a = 0.2
	timer.start()
	
func _on_timer_timeout() -> void:
	color_rect.color.a = 0.0

extends CardState


func enter() -> void:
	# We must await for the card_ui (parent node) to be ready
	# before entering the initial state. This is because in Godot
	# the children are "ready" before the "parent" is. This could cause
	# issues as the states need the card ui to function correctly.
	if not card_ui.is_node_ready():
		await card_ui.ready
		
	if card_ui.tween and card_ui.tween.is_running():
		card_ui.tween.kill()
	
	card_ui.panel.set("theme_override_styles/panel", card_ui.BASE_STYLEBOX)
	card_ui.reparent_requested.emit(card_ui)
	# ensures that the mouse does not snap to the corner of the card. but
	# the following line just resets the pivot if the card is released.
	card_ui.pivot_offset = Vector2.ZERO
	Events.tooltip_hide_requested.emit()
	
	
func on_gui_input(event: InputEvent) -> void:
	if not card_ui.playable or card_ui.disabled:
		return
	
	if event.is_action_pressed("left_mouse"):
		card_ui.pivot_offset = card_ui.get_global_mouse_position() - card_ui.global_position
		transition_requested.emit(self, CardState.State.CLICKED)

func on_mouse_entered() -> void:
	if not card_ui.playable or card_ui.disabled:
		return
	card_ui.panel.set("theme_override_styles/panel", card_ui.HOVER_STYLEBOX)
	Events.card_tooltip_requested.emit(card_ui.card.icon, card_ui.card.tooltip_text)
	
func on_mouse_exited() -> void:
	if not card_ui.playable or card_ui.disabled:
		return
	card_ui.panel.set("theme_override_styles/panel", card_ui.BASE_STYLEBOX)
	Events.tooltip_hide_requested.emit()

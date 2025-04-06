extends Node

# General
signal object_initialized(entity : Entity)

# General UI
signal resized()

# Entity Signals
signal damaged(entity : Entity)
signal died(entity : Entity)

# Enemy Signals
signal intent_changed(entity : Enemy)

# Board
signal actions_populated(action_array : Array[ActionInstance])
signal regenerate_board()

# TurnManager
signal player_turn_completed()
signal enemy_turn_completed()
signal full_turn_completed()
signal state_changed(new_state)

# Orb
signal orb_selectable(orb : Orb)
signal orb_swapped(selectedOrb : Orb, targetOrb : Orb)
signal orb_selected(orb : Orb)
signal orb_dropped(orb : Orb)

# Debug
signal debug_breakpoint()

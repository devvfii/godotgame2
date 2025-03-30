extends Node

# General
signal object_initialized(entity : Entity)

# General UI
signal resized()

# Entity Signals
signal damaged(entity : Entity)
signal died(entity : Entity)

# Board
signal actions_populated(action_array : Array[ActionInstance])

# TurnManager
signal player_turn_completed()

# Orb
signal orb_selectable(orb : Orb)
signal orb_swap(selectedOrb : Orb, targetOrb : Orb)
signal orb_selected(orb : Orb)
signal orb_dropped(orb : Orb)

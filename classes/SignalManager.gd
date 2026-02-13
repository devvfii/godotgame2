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
signal all_orbs_resolved()

# TurnManager
signal player_turn_completed()
signal enemy_turn_completed()
signal full_turn_completed()
signal state_changed(new_state)
signal exit_combat(player)

# Orb
signal orb_swapped(selectedOrb : Orb, targetOrb : Orb)
signal orb_selected(orb : Orb)
signal orb_dropped(orb : Orb)
signal orb_deleted(orb : Orb)

# MapNode
signal mapnode_selected(mapnode : MapNode)
signal enter_combat(mapnode : MapNode)

# DialogueBox
signal text_animation_done()

# Debug
signal debug_breakpoint()

extends Node

# General
signal object_initialized(entity : Entity)

# General UI
signal resized()

# Entity Signals
signal entity_blocked(entity : Entity, value : int)
signal entity_block_broken(entity : Entity)
signal entity_charged(entity : Entity, value : int)
signal entity_damaged(entity : Entity, value : int)
signal entity_died(entity : Entity)
signal entity_healed(entity : Entity, value : int)

# PlayerModule
signal get_player_reference(node : Node)

# EnemyModule

# Enemy Signals
signal intent_changed(entity : Enemy)

# Board
signal actions_populated(action_array : Array[ActionInstance])
signal all_orbs_resolved()
signal board_resolved(combos : Array)
signal clear_board()
signal generate_orbs()
signal regenerate_board()
signal resolve_board()

# TurnManager
signal player_turn_completed()
signal enemy_turn_completed()
signal full_turn_completed()
signal turn_state_changed(new_state : GlobalConstants.TURN_STATES)
signal exit_combat(player)

# Orb
signal orb_swapped(selected_orb : Orb, target_orb : Orb)
signal orb_selected(orb : Orb)
signal orb_dropped(orb : Orb)
signal orb_deleted(orb : Orb)
signal orb_resized(tile_size : float)

# MapNode
#signal mapnode_selected(mapnode : MapNode)
#signal enter_combat(mapnode : MapNode)

# DialogueBox
signal text_animation_done()

# Debug
signal debug_breakpoint()
signal debug_log(log : String)
signal debug_spawn_enemy()
signal disable_debug_ui()
signal enable_debug_ui()

extends Node2D
class_name Entity

var max_hp := 15.0
var current_hp := max_hp
var base_atk := 5.0
var effective_atk : int
var base_block := 5.0
var effective_block := 0.0
var base_heal := 3.0
var effective_heal := base_heal

var sprite : AnimatedSprite2D
var h_flip : bool

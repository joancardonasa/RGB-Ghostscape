extends Node


func _ready():
    randomize()


func choose_random(array: Array):
    return array[randi() % array.size()]


func get_player():
    return get_tree().get_nodes_in_group("Player")[0]


func get_card_manager():
    return get_tree().get_nodes_in_group("CardManager")[0]


func get_hitscan_raycast():
    return get_tree().get_nodes_in_group("WeaponHitscanRaycast")[0]


func get_ui_weapon():
    return get_tree().get_nodes_in_group("UI_Weapon")[0]

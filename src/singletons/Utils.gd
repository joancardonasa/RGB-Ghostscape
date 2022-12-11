extends Node


func _ready():
    randomize()


func choose_random(array: Array):
    return array[randi() % array.size()]

func choice(array: Array, num: int):
    var idx = range(array.size())
    var found = []
    idx.shuffle()
    for i in range(num):
        found.append(array[idx[i]])
    return found

func get_player():
    return get_tree().get_nodes_in_group("Player")[0]


func get_card_manager():
    return get_tree().get_nodes_in_group("CardManager")[0]


func get_hitscan_raycast():
    return get_tree().get_nodes_in_group("WeaponHitscanRaycast")[0]

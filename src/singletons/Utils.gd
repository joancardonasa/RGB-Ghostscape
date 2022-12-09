extends Node


func _ready():
    randomize()


func choose_random(array: Array):
    return array[randi() % array.size()]


func get_player():
    return get_tree().get_nodes_in_group("Player")[0]


func get_nav():
    return get_tree().get_nodes_in_group("Nav")[0]

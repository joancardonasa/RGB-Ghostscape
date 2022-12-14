extends Node

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

# Functions that provide utilities for all classes
# Served as a Singleton class


func _ready():
    randomize()
    rng.randomize()

# Generic Roll logic + random utilities
func roll_probability(probability_threshold: float) -> bool:
    if probability_threshold > 0:
        return rng.randf() <= probability_threshold
    return false

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

func get_weapon_manager():
    return get_tree().get_nodes_in_group("WeaponManager")[0]

#func get_ui_weapon():
#    return get_tree().get_nodes_in_group("UI_Weapon")[0]

func get_hud():
    return get_tree().get_nodes_in_group("HUD")[0]

func get_ammo_manager():
    return get_tree().get_nodes_in_group("AmmoManager")[0]

func get_ui_deck():
    return get_tree().get_nodes_in_group("UI_Deck")[0]

func get_ui_cardbox():
    return get_tree().get_nodes_in_group("UI_CardBox")[0]

# Pickup utils
func get_pickup_container():
    return get_tree().get_nodes_in_group("PickupContainer")[0]

func get_pickup_manager():
    return get_tree().get_nodes_in_group("PickupManager")[0] 

# Camera
func get_camera():
    return get_tree().get_nodes_in_group("Camera")[0]

func camera_shake(intensity, duration):
    get_camera().shake(intensity, duration)

func coalesce(value, default_value):
    if value == null:
        return default_value
    return value

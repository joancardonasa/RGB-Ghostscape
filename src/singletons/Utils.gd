extends Node


var AmmoPickup = preload("res://src/gameplay/Pickups/AmmoPickup.tscn")

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


func get_ui_weapon():
    return get_tree().get_nodes_in_group("UI_Weapon")[0]


func get_ammo_manager():
    return get_tree().get_nodes_in_group("AmmoManager")[0]

# Pickup utils
func get_pickup_container():
    return get_tree().get_nodes_in_group("PickupContainer")[0]

func spawn_ammo_pickup(position: Vector3):
    var pickup_container = get_pickup_container()
    var ammo_pickup = AmmoPickup.instance()

    # TODO: Set randomly
    if roll_probability(0.5):
        ammo_pickup.ammo_type = AmmoManager.AmmoType.SMALL
        ammo_pickup.ammo_amount = 10
    else:
        ammo_pickup.ammo_type = AmmoManager.AmmoType.LARGE
        ammo_pickup.ammo_amount = 6

    pickup_container.add_child(ammo_pickup)
    ammo_pickup.global_transform.origin = position

func get_ui_deck():
    return get_tree().get_nodes_in_group("UI_Deck")[0]
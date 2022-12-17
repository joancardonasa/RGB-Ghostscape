extends Spatial

class_name PickUpManager

var AmmoPickup = preload("res://src/gameplay/Pickups/AmmoPickup.tscn")
var CardPickup = preload("res://src/gameplay/Pickups/CardPickup.tscn")

signal PickedUpAmmo(ammo_type, ammo_amount)
signal PickedUpCard(card_type, card_amount)

var cards_droppable: Array = []

func _ready():
    load_droppable_cards()

func _on_PickupArea_area_entered(area):
    if area.is_in_group("AmmoPickup"):
        emit_signal("PickedUpAmmo", area.ammo_type, area.ammo_amount)
        area.queue_free()
    elif area.is_in_group("CardPickup"):
        emit_signal("PickedUpCard", area.card_type, area.card_amount)
        area.queue_free()


func load_droppable_cards():
    var dir = Directory.new()
    dir.open("res://data/cards/drops/")
    dir.list_dir_begin()
    var file
    while true:
        file = dir.get_next()
        if file == "":
            break
        if file.ends_with(".tres"):
            cards_droppable.append(load("res://data/cards/drops/" + file))
    dir.list_dir_end()

func spawn_pickup(position: Vector3):
    var pickup_container = Utils.get_pickup_container()
    var drop
    if Utils.roll_probability(0.8):
        drop = generate_ammo_pickup()
    else:
        drop = generate_card_pickup()
    pickup_container.add_child(drop)
    drop.global_transform.origin = position

func generate_ammo_pickup():
    var ammo_pickup = AmmoPickup.instance()

    # TODO: Set randomly
    if Utils.roll_probability(0.5):
        ammo_pickup.ammo_type = AmmoManager.AmmoType.SMALL
        ammo_pickup.ammo_amount = 5
    else:
        ammo_pickup.ammo_type = AmmoManager.AmmoType.LARGE
        ammo_pickup.ammo_amount = 2
    return ammo_pickup

func generate_card_pickup():
    var card_pickup = CardPickup.instance()
    card_pickup.card_type = cards_droppable[randi() % cards_droppable.size()].duplicate()
    card_pickup.card_amount = 1
    return card_pickup
    

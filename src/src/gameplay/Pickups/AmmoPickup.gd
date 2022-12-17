extends "res://src/gameplay/Pickups/Pickup.gd"


export(AmmoManager.AmmoType) var ammo_type = AmmoManager.AmmoType.SMALL
export(int) var ammo_amount = 0

onready var sprite = $Sprite3D


var ammo_manager = null

func _ready():
    # TODO Clean up
    ammo_manager = Utils.get_ammo_manager()
    sprite.modulate = ammo_manager.ammo_info[ammo_type]["color"]


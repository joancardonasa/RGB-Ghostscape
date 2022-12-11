extends "res://src/gameplay/Pickups/Pickup.gd"


export(AmmoManager.AmmoType) var ammo_type = AmmoManager.AmmoType.SMALL
export(int) var ammo_amount = 0


func _ready():
    # TODO Clean up
    if ammo_type == AmmoManager.AmmoType.SMALL:
        $Sprite3D.modulate = Color(0, 0, 1, 1)
    elif ammo_type == AmmoManager.AmmoType.LARGE:
        $Sprite3D.modulate = Color(1, 0, 0, 1)

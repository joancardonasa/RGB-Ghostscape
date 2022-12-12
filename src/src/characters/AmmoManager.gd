extends Spatial

class_name AmmoManager

enum AmmoType {
  SHELL,
  SMALL,
  LARGE,
}

export var ammo_info: Dictionary = {
    AmmoType.SHELL: {
        "amount": 0,
        "color": Color(1, 0, 1, 1)
    },
    AmmoType.SMALL: {
        "amount": 10,
        "color": Color(0, 0, 1, 1)
    },
    AmmoType.LARGE: {
        "amount": 3,
        "color": Color(1, 0, 0, 1)
    }
}

var weapon_manager = null

signal PickedUpAmmo(ammo_type, ammo_amount)

func _on_PickupArea_area_entered(area):
    if area.is_in_group("AmmoPickup"):
        ammo_info[area.ammo_type]["amount"] += area.ammo_amount
        emit_signal("PickedUpAmmo", area.ammo_type, area.ammo_amount)
        area.queue_free()

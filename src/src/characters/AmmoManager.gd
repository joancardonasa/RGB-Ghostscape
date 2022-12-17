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

signal update_ammo(ammo_type)

func _ready():
    var pickup_manager = Utils.get_pickup_manager()
    pickup_manager.connect("PickedUpAmmo", self, "on_ammo_pickup")

func on_ammo_pickup(ammo_type: int, amount: int):
    ammo_info[ammo_type]["amount"] += amount
    emit_signal("update_ammo", ammo_type)

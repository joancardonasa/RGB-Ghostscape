extends Spatial

class_name AmmoManager

enum AmmoType {
  SHELL,
  SMALL,
  LARGE,
}


export var ammo_amount: Dictionary = {
    AmmoType.SHELL: 0,
    AmmoType.SMALL: 30,
    AmmoType.LARGE: 6
}


func _ready():
    pass



func _on_PickupArea_area_entered(area):
    if area.is_in_group("AmmoPickup"):
        ammo_amount[area.ammo_type] += area.ammo_amount
        area.queue_free()

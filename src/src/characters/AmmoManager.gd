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
    pass # Replace with function body.

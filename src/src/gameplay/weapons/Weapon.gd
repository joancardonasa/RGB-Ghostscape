extends Spatial

class_name Weapon
# TODO Ammo type resources

export var is_active: bool = false
export(Resource) var weapon_data

onready var animation_player = $AnimationPlayer

var hitscan_raycast = null
var ui_weapon = null

var ammo_magazine: int = 0
var ammo_amount: int = 0

func _ready():
    hitscan_raycast = Utils.get_hitscan_raycast()
    ui_weapon = Utils.get_ui_weapon()

    ammo_magazine = weapon_data.magazine_size


func fire():
    if not animation_player.is_playing() and ammo_magazine > 0:
        animation_player.play("Fire")

        hitscan_raycast.enabled = true
        if hitscan_raycast.is_colliding():
            var collider = hitscan_raycast.get_collider()
            collider.take_damage(2)
        ammo_magazine -= 1
        ui_weapon.update_ammo_amount(
            ammo_magazine,
            weapon_data.magazine_size,
            ammo_amount)


func _on_HitscanTimer_timeout():
    hitscan_raycast.enabled = false

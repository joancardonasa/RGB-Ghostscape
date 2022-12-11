extends Spatial

class_name Weapon
# TODO Ammo type resources

export var is_active: bool = false
export(AmmoManager.AmmoType) var ammo_type = AmmoManager.AmmoType.SMALL

# This could be depenant on bullet, but right now it's just simpler to set it here due to some concerns (e.g how do you set flamethrower ammo damage?)
export(int) var damage = 0
export(Resource) var weapon_data
export(Texture) var crosshair_texture

onready var animation_player = $AnimationPlayer

var hitscan_raycast = null
var ui_weapon = null
var ammo_manager = null

var ammo_magazine: int = 0


func _ready():
    hitscan_raycast = Utils.get_hitscan_raycast()
    ui_weapon = Utils.get_ui_weapon()
    ammo_manager = Utils.get_ammo_manager()

    ammo_magazine = weapon_data.magazine_size


func fire():
    if not animation_player.is_playing() and ammo_magazine > 0:
        animation_player.play("Fire")

        hitscan_raycast.enabled = true
        if hitscan_raycast.is_colliding():
            var collider = hitscan_raycast.get_collider()
            collider.take_damage(damage)

        ammo_magazine -= 1

        ui_weapon.update_ammo_amount(
            ammo_magazine,
            weapon_data.magazine_size,
            ammo_manager.ammo_amount[ammo_type])


func _on_HitscanTimer_timeout():
    hitscan_raycast.enabled = false


func _on_AnimationPlayer_animation_finished(anim_name):
#    if anim_name == "Fire":
#        if ammo_magazine == 0 and ammo_manager.ammo_amount[ammo_type] > 0:
#            animation_player.play("Reload")
    if anim_name == "Reload":
        reload()


# Could also be called on purpose
func reload():
    if ammo_manager.ammo_amount[ammo_type] == 0:
        # No ammo, make sound chckhc
        return

    var amount_empty: int = weapon_data.magazine_size - ammo_magazine
    var amount_available: int = ammo_manager.ammo_amount[ammo_type]

    var amount_to_fill: int = min(amount_empty, amount_available)

    ammo_magazine += amount_to_fill
    ammo_manager.ammo_amount[ammo_type] -= amount_to_fill

    ui_weapon.update_ammo_amount(
        ammo_magazine,
        weapon_data.magazine_size,
        ammo_manager.ammo_amount[ammo_type])


func set_active(weapon: Weapon):
    # TODO: Add activate animation
    if self == weapon:
        visible = true
    else:
        visible = false


func _input(event):
    if event.is_action_pressed("reload"):
        if ammo_magazine == weapon_data.magazine_size or \
            ammo_manager.ammo_amount[ammo_type] == 0:
                return
        else:
            animation_player.play("Reload")

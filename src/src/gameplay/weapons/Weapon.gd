extends Spatial

class_name Weapon
# TODO Ammo type resources

export var is_active: bool = false
export(AmmoManager.AmmoType) var ammo_type = AmmoManager.AmmoType.SMALL

# This could be depenant on bullet, but right now it's just simpler to set it here due to some concerns (e.g how do you set flamethrower ammo damage?)
export(int) var damage = 0
export(Resource) var weapon_data
export(Texture) var crosshair_texture
export(float) var crosshair_scale_shot_time = 0.1

export(float) var camera_shake_intensity = 0.06
export(float) var camera_shake_duration = 0.06

onready var animation_player = $AnimationPlayer

var hitscan_raycast = null
var ammo_manager = null

var ammo_magazine: int = 0

var is_reloading: bool = false

signal set_active(weapon)
signal update_ammo(weapon)
signal weapon_shot(shot_time)
signal enemy_hit(hit_marker_time)


func _ready():
    hitscan_raycast = Utils.get_hitscan_raycast()
    ammo_manager = Utils.get_ammo_manager()

    ammo_magazine = weapon_data.magazine_size


func fire():
    if not animation_player.is_playing() and ammo_magazine > 0 and is_active:
        animation_player.play("Fire")
        Utils.camera_shake(camera_shake_intensity, camera_shake_duration)
        emit_signal("weapon_shot", crosshair_scale_shot_time)

        hitscan_raycast.enabled = true
        if hitscan_raycast.is_colliding():
            emit_signal("enemy_hit", 0.1)
            var collider = hitscan_raycast.get_collider()
            collider.take_damage(damage)

        ammo_magazine -= 1

        emit_signal("update_ammo", self)
    elif not animation_player.is_playing() and \
        ammo_magazine == 0 and \
        ammo_manager.ammo_info[ammo_type]["amount"] > 0:
        start_reload_anim()


func _on_HitscanTimer_timeout():
    hitscan_raycast.enabled = false


func _on_AnimationPlayer_animation_finished(anim_name):
    if anim_name == "Reload":
        is_reloading = false
        reload()


# Could also be called on purpose
func reload():
    if ammo_manager.ammo_info[ammo_type]["amount"] == 0:
        # No ammo, make sound chckhc
        return

    var amount_empty: int = weapon_data.magazine_size - ammo_magazine
    var amount_available: int = ammo_manager.ammo_info[ammo_type]["amount"]

    var amount_to_fill: int = min(amount_empty, amount_available)

    ammo_magazine += amount_to_fill
    ammo_manager.ammo_info[ammo_type]["amount"] -= amount_to_fill

    emit_signal("update_ammo", self)


func set_active(weapon: Weapon):
    # TODO: Add activate animation
    is_active = self == weapon
    visible = self == weapon
    if is_active:
        emit_signal("set_active", self)
        emit_signal("update_ammo", self)


func _input(event):
    # Only reload active weapon
    if not is_active: return
    if event.is_action_pressed("reload"):
        if ammo_magazine == weapon_data.magazine_size or \
            ammo_manager.ammo_info[ammo_type]["amount"] == 0:
                return
        else:
            start_reload_anim()


func start_reload_anim():
    is_reloading = true
    animation_player.play("Reload")

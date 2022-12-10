extends Spatial

class_name Weapon
# TODO Ammo type resources

export var is_active: bool = false
export(Resource) var weapon_data

onready var animation_player = $AnimationPlayer

var hitscan_raycast = null

func _ready():
    hitscan_raycast = Utils.get_hitscan_raycast()


func fire():
    if not animation_player.is_playing():
        animation_player.play("Fire")

        hitscan_raycast.enabled = true
        if hitscan_raycast.is_colliding():
            var collider = hitscan_raycast.get_collider()
            collider.take_damage(2)


func _on_HitscanTimer_timeout():
    hitscan_raycast.enabled = false

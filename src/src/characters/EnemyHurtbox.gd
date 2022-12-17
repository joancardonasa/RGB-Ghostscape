extends Area

var ImpactScene = preload("res://src/effects/Impact.tscn")

onready var hit_sfx = $HitSFX
onready var miss_sfx = $MissSFX

var phased : bool = false
signal damage_taken(damage_amount)
signal player_collision(area)

func take_damage(damage_amount: int, hit_location: Vector3):
    if phased:
        Sound.play(miss_sfx)
        return
    emit_signal("damage_taken", damage_amount)
    _add_impact(hit_location)
    Sound.play(hit_sfx)

func _on_Hurtbox_area_entered(area):
    if area.get("is_player"):
        emit_signal("player_collision",area)

func _add_impact(hit_location: Vector3):
    var impact_scene = ImpactScene.instance()
    add_child(impact_scene)
    impact_scene.global_transform.origin = hit_location
    #impact_scene.rotate_object_local(Vector3.UP, rand_range(0, 360))
    var scale = rand_range(0.5, 1.2)
    impact_scene.scale = Vector3(scale, scale, scale)

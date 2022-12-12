extends Control

onready var ui_ammo_label: Label = $UI_Ammo/HBoxContainer/Label
onready var ui_ammo_icon: TextureRect = $UI_Ammo/HBoxContainer/AmmoIcon 

onready var crosshair: TextureRect = $Crosshair
onready var hit_indicator: TextureRect = $Crosshair/HitIndicator

var weapon_manager = null
var ammo_manager = null

func _ready():
    weapon_manager = Utils.get_weapon_manager()
    ammo_manager = Utils.get_ammo_manager()


func update_ammo_amount(weapon: Weapon):
    ui_ammo_icon.modulate = ammo_manager.ammo_info[weapon.ammo_type]["color"]
    ui_ammo_label.text = \
        str(weapon.ammo_magazine) + "/" + \
        str(weapon.weapon_data.magazine_size) + \
        " (" + str(ammo_manager.ammo_info[weapon.ammo_type]["amount"]) + ")"


# Crosshair
func update_crosshair(texture: Texture):
    crosshair.texture = texture

func scale_crosshair_on_shot(scale_animation_time: float):
    crosshair.rect_scale = Vector2(1.2,1.2)
    var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(crosshair, "rect_scale", Vector2.ONE, scale_animation_time)


func show_hit_indicator_on_hit(animation_time: float = 0.07):
    hit_indicator.modulate = Color(1,1,1,0.5)
    var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(hit_indicator, "modulate", Color(1,1,1,0), animation_time)

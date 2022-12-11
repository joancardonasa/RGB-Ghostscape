extends Control

onready var ui_ammo_label: Label = $UI_Ammo/Label
onready var crosshair: TextureRect = $Crosshair

func _ready():
    pass


func update_ammo_amount(
    new_ammo_amount: int,
    magazine_size: int,
    total_ammo_amount: int
   ):
    ui_ammo_label.text = str(new_ammo_amount) + "/" + str(magazine_size) + \
        " (" + str(total_ammo_amount) + ")"

func update_crosshair(texture: Texture):
    crosshair.texture = texture

func ring_crosshair_on_shot():
    crosshair.rect_scale = Vector2(1.2,1.2)
    var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(crosshair, "rect_scale", Vector2.ONE, 0.1)


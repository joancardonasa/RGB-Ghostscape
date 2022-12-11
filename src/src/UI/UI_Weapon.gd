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

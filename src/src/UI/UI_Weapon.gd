extends Control


func _ready():
    pass


func update_ammo_amount(
    new_ammo_amount: int,
    magazine_size: int,
    total_ammo_amount: int
   ):
    $UI_Ammo/Label.text = str(new_ammo_amount) + "/" + str(magazine_size) + \
        " (" + str(total_ammo_amount) + ")"

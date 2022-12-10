extends Area

signal damage_taken(damage_amount)


func _ready():
    pass


func take_damage(damage_amount: int):
    emit_signal("damage_taken", damage_amount)

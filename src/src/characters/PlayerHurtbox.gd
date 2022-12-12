extends Area

var is_player = true

signal damage_taken()

func take_damage():
    emit_signal("damage_taken")

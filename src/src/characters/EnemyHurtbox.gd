extends Area

signal damage_taken(damage_amount)
signal player_collision(area)

func take_damage(damage_amount: int):
    emit_signal("damage_taken", damage_amount)

func _on_Hurtbox_area_entered(area):
    if area.get("is_player"):
        emit_signal("player_collision",area)

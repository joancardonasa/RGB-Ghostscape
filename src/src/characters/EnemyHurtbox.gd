extends Area

signal damage_taken(damage_amount, hit_location)
signal player_collision(area)

func take_damage(damage_amount: int, hit_location: Vector3):
    emit_signal("damage_taken", damage_amount, hit_location)

func _on_Hurtbox_area_entered(area):
    if area.get("is_player"):
        emit_signal("player_collision",area)

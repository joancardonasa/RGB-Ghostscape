extends Enemy

func _move():
    if is_instance_valid(player) and _moving:
        #move_and_slide(direction.normalized() * speed, Vector3.UP)
        look_at(player.global_transform.origin, Vector3.UP)

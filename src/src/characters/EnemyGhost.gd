extends Enemy

func _move():
    if is_instance_valid(player) and _moving:
        move_and_slide(direction.normalized() * speed, Vector3.UP)
        var oriRot = global_rotation
        look_at(player.global_transform.origin, Vector3.UP)
        global_rotation.x = oriRot.x
        global_rotation.z = oriRot.z


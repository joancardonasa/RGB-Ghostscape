extends Enemy

onready var player_raycast = $PlayerRaycast

var last_seen_player_pos: Vector3

func _move(delta):
    if is_instance_valid(player) and _moving:
        #move_and_slide(direction.normalized() * speed, Vector3.UP)
        var direction_to_player = global_transform.origin.direction_to(player.global_transform.origin)
        global_transform.origin += direction_to_player.normalized() * (speed/2) * delta
        look_at(player.global_transform.origin, Vector3.UP)


func _on_PlayerRaycastCheck_timeout():
    var new_player_position: Vector3 = to_local(player.global_transform.origin)
    player_raycast.cast_to = player_raycast.transform.origin.direction_to(new_player_position) 

    if player_raycast.is_colliding():
        last_seen_player_pos = player.global_transform.origin

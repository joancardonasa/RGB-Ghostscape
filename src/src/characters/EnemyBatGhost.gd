extends Enemy

onready var player_raycast = $PlayerRaycast

var last_seen_player_pos: Vector3

func _move(delta):
    if is_instance_valid(player) and _moving:
        #move_and_slide(direction.normalized() * speed, Vector3.UP)
        look_at(player.global_transform.origin, Vector3.UP)
        var direction_to_player = last_seen_player_pos - global_transform.origin
        global_transform.origin += direction_to_player.normalized() * (speed/2) * delta


func _on_PlayerRaycastCheck_timeout():
    player_raycast.cast_to = to_local(player.global_transform.origin)
    if player_raycast.is_colliding() and player_raycast.get_collider() == player:
        last_seen_player_pos = player.global_transform.origin

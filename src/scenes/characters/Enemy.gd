extends KinematicBody

export var speed = 5
export var attack_speed_multiplier = 5

var path = []
var path_node = 0

var player = null
var nav = null

func _ready():
    player = Utils.get_player()
    print(player)


#func _on_PathUpdateTimer_timeout():
#    if is_instance_valid(player):
#        move_to(player.global_transform.origin)
#
#func move_to(target_position: Vector3):
#    path = nav.get_simple_path(global_transform.origin, target_position)
#    path_node = 0

extends KinematicBody

export var speed = 5
export var attack_speed_multiplier = 5

onready var nav_agent = $NavigationAgent

var path = []
var path_node = 0

var direction: Vector3 = Vector3.ZERO

var player = null
var nav = null

func _ready():
    player = Utils.get_player()
    print(player)


func _on_PathUpdateTimer_timeout():
    if is_instance_valid(player):
        nav_agent.set_target_location(player.global_transform.origin)
        direction = global_transform.origin.direction_to(nav_agent.get_next_location())

func _physics_process(_delta):
    if is_instance_valid(player):
        move_and_slide(direction.normalized() * speed, Vector3.UP)

#
#func move_to(target_position: Vector3):
#    path = nav.get_simple_path(global_transform.origin, target_position)
#    path_node = 0

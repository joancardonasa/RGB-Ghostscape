extends KinematicBody

export var speed = 5
export var attack_speed_multiplier = 5

onready var nav_agent = $NavigationAgent

onready var mesh = $MeshInstance
onready var aura_mesh = $AuraMeshInstance

var direction: Vector3 = Vector3.ZERO

var player = null
var card_manager = null

func _ready():
    player = Utils.get_player()
    card_manager = Utils.get_card_manager()
    card_manager.connect("Enemy_Reveal", self, "_determine_visibility")
    _determine_visibility(card_manager.current_card.reveal_enemies)


func _on_PathUpdateTimer_timeout():
    if is_instance_valid(player):
        nav_agent.set_target_location(player.global_transform.origin)
        direction = global_transform.origin.direction_to(nav_agent.get_next_location())

func _physics_process(_delta):
    if is_instance_valid(player):
        move_and_slide(direction.normalized() * speed, Vector3.UP)


func _on_Hurtbox_area_entered(area):
    # Received damage
    pass


func _determine_visibility(enable: bool):
    mesh.visible = enable
    aura_mesh.visible = not enable

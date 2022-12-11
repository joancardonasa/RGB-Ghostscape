extends KinematicBody

export var speed = 5

onready var nav_agent = $NavigationAgent

onready var stats = $Stats

onready var mesh = $MeshInstance
onready var aura_mesh = $AuraMeshInstance

var direction: Vector3 = Vector3.ZERO

var player = null
var card_manager = null
var pickup_container = null

func _ready():
    player = Utils.get_player()
    card_manager = Utils.get_card_manager()
    card_manager.connect("Enemy_Reveal", self, "_determine_visibility")
    _determine_visibility(card_manager.current_card.reveal_enemies)

    pickup_container = Utils.get_pickup_container()

func _on_PathUpdateTimer_timeout():
    if is_instance_valid(player):
        nav_agent.set_target_location(player.global_transform.origin)
        direction = global_transform.origin.direction_to(nav_agent.get_next_location())

func _physics_process(_delta):
    if is_instance_valid(player):
        move_and_slide(direction.normalized() * speed, Vector3.UP)

func _determine_visibility(enable: bool):
    mesh.visible = enable
    aura_mesh.visible = not enable


# Health/Damage
func _on_Hurtbox_damage_taken(amount: int):
    stats.take_hit(amount)

func _on_Hurtbox_player_collision(player_hurtbox : Area):
    player_hurtbox.take_damage()
    _die()

func _on_Stats_died_signal():
    Utils.spawn_ammo_pickup(global_transform.origin)
    _die()

func _die():
    queue_free()

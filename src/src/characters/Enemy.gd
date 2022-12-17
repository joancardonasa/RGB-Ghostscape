extends KinematicBody

var EnemyDeathScene = preload("res://src/characters/EnemyDeathScene.tscn")

export var speed = 5
export(Material) var normal_material
export(Material) var hidden_material
export(Material) var hit_material

onready var nav_agent = $NavigationAgent

onready var stats = $Stats
onready var hit_anim_timer = $ghost/HitAnimTimer
onready var hurtbox = $Hurtbox

var direction: Vector3 = Vector3.ZERO

var player = null
var card_manager = null
var pickup_container = null

func _ready():
    player = Utils.get_player()
    card_manager = Utils.get_card_manager()
    card_manager.connect("Enemy_Reveal", self, "_determine_visibility")
    _determine_visibility(Utils.coalesce(card_manager.current_card.get("reveal_enemies"), false))

    pickup_container = Utils.get_pickup_container()
    hit_anim_timer.connect("timeout", self, "_on_HitAnimTimer_timeout")

func _on_PathUpdateTimer_timeout():
    if is_instance_valid(player):
        nav_agent.set_target_location(player.global_transform.origin)
        direction = global_transform.origin.direction_to(nav_agent.get_next_location())

func _physics_process(_delta):
    if is_instance_valid(player):
        move_and_slide(direction.normalized() * speed, Vector3.UP)
        look_at(player.global_transform.origin, Vector3.UP)

func _determine_visibility(enable: bool):
    $ghost/ghost.set_surface_material(2, 
        normal_material if enable else hidden_material)
    hurtbox.phased = not enable


# Health/Damage
func _on_Hurtbox_damage_taken(amount: int):
    stats.take_hit(amount)
    $ghost/ghost.set_surface_material(2, hit_material)
    hit_anim_timer.start()

func _on_Hurtbox_player_collision(player_hurtbox : Area):
    player_hurtbox.take_damage()
    _die()

func _on_Stats_died_signal():
    Utils.get_pickup_manager().spawn_pickup(global_transform.origin)
    Counter.ENEMIES_KILLED += 1
    _die()

func _die():
    var death_scene = EnemyDeathScene.instance()
    # Actually instance where it should go, in Map
    var main = Utils.get_pickup_container()
    main.add_child(death_scene)
    death_scene.global_transform.origin = global_transform.origin + Vector3(0, 2, 0)
    queue_free()

func _on_HitAnimTimer_timeout():
    _determine_visibility(Utils.coalesce(card_manager.current_card.get("reveal_enemies"), false))

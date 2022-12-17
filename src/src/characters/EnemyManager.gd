extends Spatial

var EnemyGhost = preload("res://src/characters/EnemyGhost.tscn")
var BatGhost = preload("res://src/characters/EnemyBatGhost.tscn")

# Array of Position3D nodes
onready var enemy_spawn_positions: Array = $EnemySpawnPositions.get_children()

onready var spawn_timer = $EnemySpawnTimer

export(float) var enemy_speed = 8

func _ready():
    pass


func spawn_enemy():
    # TODO: Node where we dump enemies, should be map, or wherever player is
    var main = get_parent()

    var enemy
    if Utils.roll_probability(0.25):
        enemy = BatGhost.instance()
    else:
        enemy = EnemyGhost.instance()
    main.add_child(enemy)

    enemy.speed = enemy_speed
    enemy.global_transform.origin = get_random_spawn_position()


func get_random_spawn_position() -> Vector3:
    # IDEA: Would be cool to prioritize spawn points closer to the player
    # TODO: Make them spawn at player ground level or at least fall immediately
    if enemy_spawn_positions and len(enemy_spawn_positions) > 0:
        return Utils.choose_random(enemy_spawn_positions).global_transform.origin
    return Vector3.ZERO


func _on_EnemySpawnTimer_timeout():
    # TODO: Return if max enemies are alive, depends on wave
    spawn_enemy()


func _on_WaveManager_wave_started(current_wave):
    # 1.5, 1.4, ..., 0.5 at Wave 10
    spawn_timer.wait_time = clamp(0.5 - (current_wave-1)*0.1, 0.2, 1.5)
    spawn_timer.start()
    enemy_speed = clamp(enemy_speed + 1, 8, 20)


func _on_WaveManager_rest_started():
    spawn_timer.stop()
    get_tree().call_group("Enemy", "_die")

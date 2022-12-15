extends Spatial

var Enemy = preload("res://src/characters/Enemy.tscn")

# Array of Position3D nodes
onready var enemy_spawn_positions: Array = $EnemySpawnPositions.get_children()

func _ready():
    $EnemySpawnTimer.start()


func spawn_enemy():
    # TODO: Node where we dump enemies, should be map, or wherever player is
    var main = get_parent()
    var enemy = Enemy.instance()
    main.add_child(enemy)

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

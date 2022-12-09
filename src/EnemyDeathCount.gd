extends Node


var _enemies_dead: int = 0

func update_enemy_death_count():
    _enemies_dead += 1
    print(_enemies_dead)

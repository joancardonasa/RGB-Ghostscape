extends Control

onready var _transition = $SceneTransition;

func ready():
    _transition.fade_out()

func _on_PlayButton_pressed():
    var a_player = _transition.fade_in()
    yield(a_player, "animation_finished")
    SceneManager.goto_scene("res://src/maps/Map.tscn")

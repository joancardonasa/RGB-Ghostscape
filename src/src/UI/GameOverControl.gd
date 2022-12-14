extends CanvasLayer


onready var enemies_killed: Label = $GameOverMenu/GameOverStats/EnemiesKilled/StatLabel

func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

    enemies_killed.text = str(Counter.ENEMIES_KILLED)

func _on_RestartButton_pressed():
    SceneManager.goto_scene("res://src/maps/Map.tscn")


func _on_MainMenuButton_pressed():
    SceneManager.goto_scene("res://src/main/MainMenu.tscn")

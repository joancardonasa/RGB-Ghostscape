extends CanvasLayer

onready var music_checkbox = $PauseMenu/MusicCheckBox

func _enter_tree():
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    pause(true)

func _ready():
    music_checkbox.toggle_mode = MusicManager.get_node("MusicPlayer").playing

func die():
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    pause(false)
    queue_free()

func pause(enable: bool):
    get_tree().paused = enable
    Globals.PAUSED = enable


func _on_ContinueButton_pressed():
    die()


func _on_RestartButton_pressed():
    pause(false)
    SceneManager.goto_scene("res://src/maps/Map.tscn")


func _on_MainMenuButton_pressed():
    pause(false)
    SceneManager.goto_scene("res://src/main/MainMenu.tscn")


func _on_CheckBox_toggled(button_pressed):
    MusicManager.get_node("MusicPlayer").playing = button_pressed

# Author Kamyab Nazari - 2021

extends Control

# MainMenu of the Game
onready var _transition = $SceneTransition;
onready var creditsPanel = $CreditsPanel;
onready var music_checkbox = $MusicCheckBox;

func _ready():
    _transition.fade_out()
    music_checkbox.toggle_mode = MusicManager.get_node("MusicPlayer").playing

func _on_PlayButton_pressed():
    var a_player = _transition.fade_in()
    yield(a_player, "animation_finished")
    SceneManager.goto_scene("res://src/main/Tutorial.tscn")

func _on_ExitButton_pressed():
    get_tree().quit()

func _on_CreditsButton_pressed():
    creditsPanel.visible = true;

func _on_CloseButton_pressed():
    creditsPanel.visible = false;


func _on_MusicCheckBox_toggled(button_pressed):
    MusicManager.get_node("MusicPlayer").playing = button_pressed

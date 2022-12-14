extends Node

var PauseControl = preload("res://src/UI/PauseControl.tscn")

func _input(event):
    if event.is_action_pressed("ui_cancel"):
        if not Globals.PAUSED:
            var pause_control = PauseControl.instance()
            self.add_child(pause_control)
        else:
            get_tree().call_group("PauseControl", "die")


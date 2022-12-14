extends Container

signal CardBox_AllowShoot(allow)

func _ready():
    set_active(false)

func _input(event):
    if event.is_action_pressed("open_box"):
        set_active(true)
    elif event.is_action_released("open_box"):
        set_active(false)

func set_active(enabled: bool):
    visible = enabled
    emit_signal("CardBox_AllowShoot", not enabled)
    if(enabled):
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    else:
        Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

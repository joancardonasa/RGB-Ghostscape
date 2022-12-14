extends CanvasLayer


func _enter_tree():
    pause(true)

func die():
    pause(false)
    queue_free()

func pause(enable: bool):
    get_tree().paused = enable

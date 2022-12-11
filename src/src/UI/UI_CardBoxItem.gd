extends ColorRect

func _ready():
    add_to_group("DRAGGABLE")

func get_drag_data(_position: Vector2):
    return self

extends ColorRect

export(Resource) var card_data
export(int) var count = 1

onready var _label_count = $Label
func _ready():
    add_to_group("DRAGGABLE")
    _set_card(card_data, count)

func get_drag_data(_position: Vector2):
    set_drag_preview(_preview_drag())
    return self

func _set_card(card: Resource, card_count: int):
    card_data = card
    count = card_count
    color = card_data.col
    if count > 1:
        _label_count.text = str(count)
    else:
        _label_count.text = ""
    
func _preview_drag():
    var preview = ColorRect.new()
    preview.rect_size = rect_size * 0.35
    preview.color = color
    preview.rect_rotation = 45
    return preview

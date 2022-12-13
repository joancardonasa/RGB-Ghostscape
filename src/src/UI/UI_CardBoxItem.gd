extends ColorRect

export(Resource) var card_data
export(int) var count = 1

onready var _label_count = $Label
func _ready():
    add_to_group("DRAGGABLE")
    _set_card(card_data, count)
    print("RD")

func get_drag_data(_position: Vector2):
    if(count<=0):
        return
    set_drag_preview(_preview_drag())
    _set_count(count - 1)
    return self

func _set_card(card: Resource, card_count: int):
    card_data = card
    color = card_data.col
    _set_count(card_count)
    
func _preview_drag():
    var preview = ColorRect.new()
    preview.rect_size = rect_size * 0.35
    preview.color = color
    preview.rect_rotation = 45
    return preview
    
func _set_count(new_count: int):
    # Do not decrease or add cards once we get to 10
    if(count>=10):
        new_count = 10
    count = new_count
    if count >= 10:
        _label_count.text = ""
    else:
        _label_count.text = str(count)
    if count == 0:
        var gvalue: float = card_data.col.gray()
        color = Color(gvalue,gvalue,gvalue,0.5)
        print(color)
    else:
        color = card_data.col

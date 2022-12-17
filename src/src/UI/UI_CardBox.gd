extends Container

signal CardBox_Enabled(enabled)

onready var container = $ColorRect/HBoxContainer
onready var open_sfx = $OpenSFX
onready var close_sfx = $CloseSFX

func _ready():
    set_active(false)
    Utils.get_pickup_manager().connect("PickedUpCard", self, "_on_pick_up_card")

func _input(event):
    if event.is_action_pressed("open_box"):
        set_active(true)
    elif event.is_action_released("open_box"):
        set_active(false)

func set_active(enabled: bool):
    visible = enabled
    emit_signal("CardBox_Enabled", enabled)
    Sound.play(open_sfx if enabled else close_sfx)
    if(enabled):
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    else:
        Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func get_cards():
    return container.get_children()

func _on_pick_up_card(card: Resource, amount: int):
    for child in container.get_children():
        if child.card_data.name == card.name:
            child.add_card(amount)

extends Control


var UI_Card = preload("res://src/UI/UI_Card.tscn")
onready var card_container = $CardContainer
var card_manager
var deck = {}
var preview_card: Control
var preview_pos: int = -1

func _ready():
    card_manager = Utils.get_card_manager()
    _clear_deck()
    card_manager.connect("Draw_Card",self, "_draw_card")
    preview_card = UI_Card.instance()

    _set_deck(card_manager.deck)

func _clear_deck():
    for card in card_container.get_children():
        card.queue_free()

func _set_deck(cards: Array):
    for card in cards:
        var card_instance = UI_Card.instance()
        card_container.add_child(card_instance)
        card_instance.set_card(card)
        deck[card.get_instance_id()] = card_instance

func _draw_card(card: Resource, duration: float):
    var card_instance = deck[card.get_instance_id()]
    card_instance.activate(duration)
    _reorder_deck(card_manager.get_ordered_deck())

func _reorder_deck(newOrder):
    # Hacky way to wait the anim time for the node to deactivate
    yield(get_tree().create_timer(0.75), "timeout")
    for child in card_container.get_children():
        card_container.remove_child(child)
    for card in newOrder:
        card_container.add_child(deck[card.get_instance_id()])
        
func can_drop_data(position: Vector2, data):
    var can_drop = data is Node and data.is_in_group("DRAGGABLE")
    if not can_drop:
        return false
    var idx = _idx_from_pos(position)
    if idx != preview_pos:
        if preview_pos == -1:
            card_container.add_child(preview_card)
            preview_card.set_card(data.card_data)
        card_container.move_child(preview_card, idx)
        preview_pos = idx
    return can_drop

func drop_data(position: Vector2, data):
    print(data)
    
func _idx_from_pos(pos: Vector2) -> int:
    var idx = 0
    for child in card_container.get_children():
        if pos.y < (child.get_position().y + (child.get_size().y/2)):
            return idx
        idx += 1
    return idx



func _on_UI_Deck_mouse_exited():
    if preview_pos != -1:
        card_container.remove_child(preview_card)
        preview_pos = -1

extends Control


var UI_Card = preload("res://src/UI/UI_Card.tscn")
onready var card_container = $ScreenSplit/CardContainer
var card_manager

func _ready():
    card_manager = Utils.get_card_manager()
    _clear_deck()
    card_manager.connect("Refresh_Deck",self, "_set_deck")
    _set_deck(card_manager.deck)

func _clear_deck():
    for card in card_container.get_children():
        card.queue_free()

func _set_deck(cards: Array):
    for card in cards:
        var card_instance = UI_Card.instance()
        card_instance.set_card(card)
        card_container.add_child(card_instance)

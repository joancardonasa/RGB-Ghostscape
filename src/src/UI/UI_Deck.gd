extends Control


var UI_Card = preload("res://src/UI/UI_Card.tscn")
onready var card_container = $CardContainer
var card_manager
var deck = {}

func _ready():
    card_manager = Utils.get_card_manager()
    _clear_deck()
    card_manager.connect("Draw_Card",self, "_draw_card")
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
    for child in card_container.get_children():
        card_container.remove_child(child)
    for card in newOrder:
        card_container.add_child(deck[card.get_instance_id()])  
    

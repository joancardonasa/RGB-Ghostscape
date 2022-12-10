extends ColorRect

func _ready():
    var cardManager = get_tree().get_nodes_in_group("CardManager")[0]
    cardManager.connect("Card_Color", self, "on_card_color")

func on_card_color(color):
    self.color = color

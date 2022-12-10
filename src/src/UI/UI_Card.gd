extends ColorRect
var cardData

func set_card(card: Resource):
    cardData = card
    self.color = cardData.col

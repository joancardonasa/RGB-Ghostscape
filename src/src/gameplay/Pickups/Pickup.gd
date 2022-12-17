extends Area


func _ready():
    var card_manager = Utils.get_card_manager()
    card_manager.connect("Pickup_Reveal", self, "_on_Card_PickupReveal")
    card_manager.connect("Pickup_Delete", self, "_on_Card_PickupDelete")

    _determine_visibility(Utils.coalesce(card_manager.current_card.get("reveal_pickups"),false))


# Card functionality
func _on_Card_PickupReveal(enable: bool):
    _determine_visibility(enable)

func _determine_visibility(enable: bool):
    visible = enable
    $CollisionShape.disabled = not enable

func _on_Card_PickupDelete():
    queue_free()

extends Area

onready var ray_floor = $RayCastFloor

func _ready():
    var card_manager = Utils.get_card_manager()
    card_manager.connect("Pickup_Reveal", self, "_on_Card_PickupReveal")
    card_manager.connect("Pickup_Delete", self, "_on_Card_PickupDelete")

    _determine_visibility(Utils.coalesce(card_manager.current_card.get("reveal_pickups"),false))

func _physics_process(delta):
    if visible:
        if ray_floor.is_colliding():
            var normal = ray_floor.get_collision_normal()
            var angle = normal.angle_to(Vector3(0,1,0))
            global_transform.rotated(Vector3(1,0,0), angle)
            
        else:
            global_transform.origin.y -= 2.8 * delta

# Card functionality
func _on_Card_PickupReveal(enable: bool):
    _determine_visibility(enable)

func _determine_visibility(enable: bool):
    visible = enable
    $CollisionShape.disabled = not enable

func _on_Card_PickupDelete():
    queue_free()

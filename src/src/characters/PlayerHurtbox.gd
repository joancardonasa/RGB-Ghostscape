extends Area

onready var invul_timer = $InvulTimer

var is_player = true
onready var collider = $CollisionShape
signal damage_taken()

func _ready():
    invul_timer.connect("timeout", self, "invul_timer_timeout")

func take_damage():
    emit_signal("damage_taken")
    collider.disabled = true
    invul_timer.start()

func invul_timer_timeout():
    collider.disabled = false

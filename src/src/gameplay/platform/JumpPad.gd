extends Area

class_name JumpPad

export var height: float = 25
export var time: float = 0.75

onready var _player = Utils.get_player()
onready var _collider = $CollisionShape
onready var _mesh = $MeshInstance

func _on_JumpArea_body_entered(body):
    if body == _player:
        var tween = Tween.new()
        # Can't put the tweens in a export because godot doesn't allow export of other classes enum
        tween.interpolate_property(
            _player,
            "translation:y",
            _player.translation.y,
            height,
            time,
            Tween.TRANS_SINE,
            Tween.EASE_OUT
        )
        add_child(tween)
        tween.start()

func set_enabled(enabled):
    _collider.disabled = !enabled
    _mesh.visible = enabled

extends Area

class_name JumpPad

export var height: float = 25
export var time: float = 0.75

var _player

func _ready():
    _player = Utils.get_player()

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

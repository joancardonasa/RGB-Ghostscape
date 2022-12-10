extends Area

class_name JumpPad

export var strength: float = 50
var _player

func _ready():
	_player = get_tree().get_nodes_in_group("Player")[0]

func _on_JumpArea_body_entered(body):
	if body == _player:
		pass


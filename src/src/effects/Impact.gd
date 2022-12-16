extends CSGMesh
export(Material) var final_material

onready var timer = $ChangeColor

func _ready():
    timer.connect("timeout", self, "_on_Timer_timeout")

func _on_Timer_timeout():
    material = final_material

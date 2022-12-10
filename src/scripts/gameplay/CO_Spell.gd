# Author Kamyab Nazari - 2021

extends Spatial

export(PackedScene) var Projectile

export var projectile_speed = 20
export var millis_between_shots = 200

onready var rof_timer = $Timer
var time_to_shoot = true
var can_shoot = false

func _ready():
	rof_timer.wait_time = millis_between_shots / 1000.0
	get_tree().get_nodes_in_group("CardManager")[0].connect("Player_AllowShoot", self, "_on_Card_AllowShoot")
	

func shoot():
	if time_to_shoot and can_shoot:
		ScSound.get_node("FireSound").play()
		var new_projectile = Projectile.instance()
		new_projectile.global_transform = $Muzzle.global_transform
		new_projectile.speed = projectile_speed
		var scene_root = get_tree().get_root().get_children()[0]
		scene_root.add_child(new_projectile)
		time_to_shoot = false
		rof_timer.start()

func _on_Timer_timeout():
	time_to_shoot = true

func _on_Card_AllowShoot(enable):
	can_shoot = enable
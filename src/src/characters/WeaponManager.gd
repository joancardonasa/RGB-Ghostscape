extends Spatial

onready var weapon_socket = $WeaponSocket
onready var weapons = $WeaponSocket.get_children()

onready var ui_weapon = $UI_Weapon

var active_weapon = null
var ammo_manager = null

var _shooting_allowed: bool = false
# Define signal to get new weapon set

func _ready():
    var card_manager = Utils.get_card_manager()
    ammo_manager = Utils.get_ammo_manager()
    card_manager.connect("Player_AllowShoot", self, "_on_Card_AllowShoot")
    for weapon in weapons:
        if weapon.is_active:
            active_weapon = weapon
            weapon.visible = true
        else:
            weapon.visible = false
    ui_weapon.update_ammo_amount(
        active_weapon.ammo_magazine,
        active_weapon.weapon_data.magazine_size,
        ammo_manager.ammo_amount[active_weapon.ammo_type])


func _input(event):
    if _shooting_allowed and is_instance_valid(active_weapon):
        if event.is_action_pressed("fire") and not active_weapon.weapon_data.automatic:
            active_weapon.fire()
            return

    determine_weapon_change(event)


func _physics_process(delta):
    if _shooting_allowed and is_instance_valid(active_weapon):
        if Input.is_action_pressed("fire") and active_weapon.weapon_data.automatic:
            active_weapon.fire()


func _on_Card_AllowShoot(enable : bool):
    _shooting_allowed = enable


func determine_weapon_change(event: InputEvent):
    if event.is_action_pressed("scroll_weapon_down"):
        var new_index: int = weapons.find(active_weapon, 0) - 1
        if new_index < 0: new_index = len(weapons) - 1
        active_weapon.visible = false
        active_weapon = weapons[new_index]
        active_weapon.visible = true
    elif event.is_action_pressed("scroll_weapon_up"):
        var new_index: int = weapons.find(active_weapon, 0) + 1
        if new_index >= len(weapons): new_index = 0
        active_weapon.visible = false
        active_weapon = weapons[new_index]
        active_weapon.visible = true
    ui_weapon.update_ammo_amount(
        active_weapon.ammo_magazine,
        active_weapon.weapon_data.magazine_size,
        ammo_manager.ammo_amount[active_weapon.ammo_type])

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
    Utils.get_ui_cardbox().connect("CardBox_AllowShoot", self, "_on_Card_AllowShoot")

    for weapon in weapons:
        if weapon.is_active:
            set_new_active_weapon(weapon)


func _input(event):
    if _shooting_allowed and is_instance_valid(active_weapon):
        if event.is_action_pressed("fire") and not active_weapon.weapon_data.automatic:
            active_weapon.fire()
            return

    determine_weapon_change(event)


func _physics_process(_delta):
    if _shooting_allowed and is_instance_valid(active_weapon):
        if Input.is_action_pressed("fire") and active_weapon.weapon_data.automatic:
            active_weapon.fire()


func _on_Card_AllowShoot(enable : bool):
    _shooting_allowed = enable


func determine_weapon_change(event: InputEvent):
    var new_index: int = 0
    if event.is_action_pressed("scroll_weapon_down"):
        new_index = weapons.find(active_weapon, 0) - 1
        if new_index < 0: new_index = len(weapons) - 1
    elif event.is_action_pressed("scroll_weapon_up"):
        new_index = weapons.find(active_weapon, 0) + 1
        if new_index >= len(weapons): new_index = 0
    else:
        return

    if active_weapon.is_reloading: return
    set_new_active_weapon(weapons[new_index])


func set_new_active_weapon(weapon: Weapon):
    active_weapon = weapon
    get_tree().call_group("Weapon", "set_active", weapon)
    ui_weapon.update_crosshair(active_weapon.crosshair_texture)
    ui_weapon.update_ammo_amount(active_weapon)


func _on_AmmoManager_PickedUpAmmo(ammo_type, ammo_amount):
    if active_weapon.ammo_type != ammo_type:
        return
    ui_weapon.update_ammo_amount(active_weapon)

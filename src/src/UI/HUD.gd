extends CanvasLayer


onready var speed_lines = $SpeedLines

onready var hp_progress_bar = $HUD_UI/HP/ProgressBarBackground/ProgressBar

onready var ammo_icon = $HUD_UI/Ammo/HBoxContainer/AmmoIcon
onready var ammo_label = $HUD_UI/Ammo/HBoxContainer/Label

onready var crosshair = $HUD_UI/Crosshair
onready var hit_indicator = $HUD_UI/Crosshair/HitIndicator

onready var hurt_vignette_anim_player = $HUD_UI/HurtVignette/AnimationPlayer

var card_manager = null
var weapon_manager = null
var ammo_manager = null

func _ready():
    card_manager = Utils.get_card_manager()
    card_manager.connect("Player_SpeedMult", self, "_on_Card_SpeedMult")

    weapon_manager = Utils.get_weapon_manager()
    weapon_manager.connect("update_ammo", self, "update_ammo_amount")

    var weapons = get_tree().get_nodes_in_group("Weapon")
    for weapon in weapons:
        weapon.connect("set_active", self, "update_crosshair")
        weapon.connect("update_ammo", self, "update_ammo_amount")
        weapon.connect("weapon_shot", self, "scale_crosshair_on_shot")
        weapon.connect("enemy_hit", self, "show_hit_indicator_on_hit")

    ammo_manager = Utils.get_ammo_manager()


# HP
func update_hp_bar_amount(new_amount: int):
    hp_progress_bar.value = new_amount

func _on_Stats_hp_updated(new_hp):
    update_hp_bar_amount(new_hp)


# Ammo
func update_ammo_amount(weapon: Weapon):
    ammo_icon.modulate = ammo_manager.ammo_info[weapon.ammo_type]["color"]
    ammo_label.text = \
        str(weapon.ammo_magazine) + "/" + \
        str(weapon.weapon_data.magazine_size) + \
        " (" + str(ammo_manager.ammo_info[weapon.ammo_type]["amount"]) + ")"

# Crosshair
func update_crosshair(weapon: Weapon):
    crosshair.texture = weapon.crosshair_texture

func scale_crosshair_on_shot(scale_animation_time: float):
    crosshair.rect_scale = Vector2(1.2,1.2)
    var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(crosshair, "rect_scale", Vector2.ONE, scale_animation_time)

func show_hit_indicator_on_hit(animation_time: float = 0.07):
    hit_indicator.modulate = Color(1,1,1,0.5)
    var tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(hit_indicator, "modulate", Color(1,1,1,0), animation_time)



# Speedlines
func _on_Card_SpeedMult(enable : bool, _mult : float):
    activate_speed_lines(enable)

func activate_speed_lines(enable: bool):
    speed_lines.emitting = enable


# Hurt Vignette
func flash_hurt_vignette():
    hurt_vignette_anim_player.play("PlayHurt")
# Wave
func update_wave_info(state_name: String):
    $HUD_UI/Wave/StageTitle.text = state_name
    $HUD_UI/Wave/VBoxContainer/StateLabel.text = state_name
    $HUD_UI/Wave/StageTitle/AnimationPlayer.play("FlashTitle")

func update_wave_timer(state_time: String, total_time: String = ""):
    $HUD_UI/Wave/VBoxContainer/StateTimerLabel.text = state_time
    #$HUD_UI/Wave/VBoxContainer/TotalTimerLabel.text = total_time




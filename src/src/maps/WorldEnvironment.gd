extends WorldEnvironment


func _ready():
    pass




func _on_WaveManager_rest_started():
    environment.background_color = Color("ecfffb")


func _on_WaveManager_wave_started(current_wave):
    pass
    #environment.background_color = Color("a73e2c")


func _on_CardManager_Draw_Card(card,_duration):
    #print(card.col)
    environment.background_color = card.col

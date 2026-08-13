extends Button
const PLAY_MENU = preload("res://menus/chooselife.tscn")
var tracks = [
	preload("res://music/At_The_Ravens_door_Main_Menu_theme_of_Avery_Must_Die.mp3"),
]
func _pressed():
	for child in get_tree().get_root().get_children():
		if child is AudioStreamPlayer:
			child.stop()
			child.queue_free()
	get_tree().change_scene_to_packed(PLAY_MENU)

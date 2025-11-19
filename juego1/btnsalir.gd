extends Button

# La ruta completa a tu escena de menú principal.
# Es CRÍTICO que esta ruta sea exactamente la correcta (incluyendo la extensión .tscn).
const MENU_SCENE_PATH = "res://menu/principal.tscn"


# Esta función se ejecuta cuando se presiona el botón, si está conectado.
func _on_btnsalir_pressed():
	
	print("Saliendo de la partida y volviendo al menú: ", MENU_SCENE_PATH)

	# Usamos get_tree().change_scene_to_file() para cargar la nueva escena (el menú).
	var error = get_tree().change_scene_to_file(MENU_SCENE_PATH)
	
	if error != OK:
		# Si hay un error, se imprime un mensaje de depuración.
		# Esto ocurre si la ruta es incorrecta o el archivo no existe.
		print("ERROR: No se pudo cambiar de escena. Asegúrate que la ruta sea correcta.")
		print("Ruta usada: ", MENU_SCENE_PATH)

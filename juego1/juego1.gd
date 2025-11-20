extends Control

# Variables del juego
var turn := "X"
var board := []
var board_state: Array[String] = []

func _ready():
	# Inicializar el estado del tablero
	for i in range(9):
		board_state.append("")
		
	# Obtener los botones de las celdas
	board = $Board.get_children()
	
	for i in range(board.size()):
		var button = board[i] as Button
		button.text = ""
		
		# Hacemos el botón plano (flat) para que se vea la animación debajo
		# y para que el botón no oculte el contenido de su hijo (Cell_tsn).
		button.flat = true 
		
		# Conectar el botón a la función con el índice de la celda
		button.pressed.connect(_on_cell_pressed.bind(i))
		
	# Conexión del botón de salida
	$btnsalir.pressed.connect(_on_btnsalir_pressed)
	
	# Inicializar el panel de ganador como invisible
	$WinnerPanel.visible = false
	# Cuando no es visible, debe configurarse para ignorar la entrada y no bloquear los clics
	$WinnerPanel.mouse_filter = Control.MOUSE_FILTER_IGNORE 

# Función que se ejecuta al presionar una celda
func _on_cell_pressed(index):
	# Evitar hacer algo si la celda ya está ocupada
	if board_state[index] != "":
		return
	
	var pressed_button = board[index] as Button
	
	# Actualizar el estado del tablero
	board_state[index] = turn
	
	# Obtener el nodo de animación (Cell_tsn)
	var cell_animation_node = pressed_button.get_node_or_null("Cell_tsn")
	
	# Llamar a la función de dibujo/animación del símbolo
	if cell_animation_node != null and cell_animation_node.has_method("draw_symbol"):
		cell_animation_node.draw_symbol(turn)
	else:
		# En caso de emergencia o error, mostramos el símbolo como texto
		pressed_button.text = turn 

	# Desactivar el botón para que no se pueda volver a presionar
	pressed_button.disabled = true
	
	# Lógica de victoria/empate
	if check_winner(turn): # <--- Si hay ganador, la función check_winner se encarga de la espera/modal
		return
		
	if check_draw():
		# Para el empate, mostramos el modal inmediatamente
		show_winner_panel("Empate")
		return
		
	# Cambiar de turno
	turn = "O" if turn == "X" else "X"

# Función para verificar si hay un ganador
# Función para verificar si hay un ganador
func check_winner(player):
	# Combinaciones ganadoras
	var wins = [
		[0,1,2], [3,4,5], [6,7,8],
		[0,3,6], [1,4,7], [2,5,8],
		[0,4,8], [2,4,6]
	]

	for w in wins:
		if board_state[w[0]] == player and board_state[w[1]] == player and board_state[w[2]] == player:
			highlight_win(w)
			
			# 1. Deshabilitar inmediatamente todas las celdas restantes para evitar más clics
			for cell in board:
				(cell as Button).disabled = true
				
			# 2. Usar un Tween para crear una pausa de 3 segundos
			var tween = create_tween()
			tween.tween_interval(3.0) # Espera de 3 segundos
			
			# 3. Después de la espera, llamar a la función que muestra el panel
			# CORRECCIÓN DEFINITIVA: Usamos .bind() en la referencia a la función misma.
			tween.tween_callback(show_winner_panel.bind(player))
			
			return true

	return false
# Función para verificar si hay empate
func check_draw():
	for state in board_state:
		if state == "":
			return false # Aún hay celdas vacías
	return true # Todas las celdas están llenas

# Función para resaltar las celdas ganadoras
func highlight_win(indices):
	for i in indices:
		var button = board[i] as Button
		# Usamos color verde para resaltar al ganar
		button.add_theme_color_override("font_color", Color.GREEN)
	pass

# Función para mostrar el panel de ganador con animación (se ejecuta después de la espera)
func show_winner_panel(player):
	# El panel de victoria debe interceptar clics para que no se siga jugando
	$WinnerPanel.mouse_filter = Control.MOUSE_FILTER_STOP
	$WinnerPanel.visible = true
	
	if player == "Empate":
		$WinnerPanel/fondo/LabelWinner.text = "¡Empate!"
	else:
		$WinnerPanel/fondo/LabelWinner.text = "Ganó el jugador " + player
		
	# La desactivación de celdas restantes ya se hizo en check_winner
		
	# Animación de aparición del panel de victoria
	$WinnerPanel.pivot_offset = $WinnerPanel.size / 2
	$WinnerPanel.scale = Vector2(0.01, 0.01)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property($WinnerPanel, "scale", Vector2(1.0, 1.0), 0.5)

# Función conectada al botón de reiniciar
func _on_RestartButton_pressed():
	restart_game()

# Función para reiniciar el juego
func restart_game():
	turn = "X"
	board_state.clear()
	for i in range(9):
		board_state.append("")
	
	for cell in board:
		var button = cell as Button
		button.disabled = false
		button.add_theme_color_override("font_color", Color.WHITE)
		button.text = "" # Limpiamos el texto de emergencia si se usó
		
		# Llamar a la función de reinicio de la escena de animación
		var cell_animation_node = button.get_node_or_null("Cell_tsn")
		if cell_animation_node and cell_animation_node.has_method("reset"):
			cell_animation_node.reset()
			
	# Ocultar el panel de victoria y permitir clics nuevamente
	$WinnerPanel.visible = false
	$WinnerPanel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
# Función para salir y volver al menú
func _on_btnsalir_pressed():
	const MENU_SCENE_PATH = "res://menu/principal.tscn"
	print("Cambiando a escena de menú: ", MENU_SCENE_PATH)
	var error = get_tree().change_scene_to_file(MENU_SCENE_PATH)
	if error != OK:
		print("Error al cambiar de escena. Asegúrate que la ruta sea correcta y el archivo exista.")

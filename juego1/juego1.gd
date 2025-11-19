extends Control

var turn := "X" 
var board := [] 

func _ready():
	board = $Board.get_children()
	for i in range(board.size()):
		board[i].pressed.connect(_on_cell_pressed.bind(i))
	# Línea CORRECTA (ya que btnsalir es un hijo directo de la raíz)
	$btnsalir.pressed.connect(_on_btnsalir_pressed)
	$WinnerPanel.visible = false

func _on_cell_pressed(index):
	var cell = board[index]
	if cell.text != "":
		return
	cell.text = turn
	if check_winner(turn):
		show_winner(turn)
		return
	if check_draw():
		show_winner("Empate")
		return
	turn = "O" if turn == "X" else "X"

func check_winner(player):
	var wins = [
		[0,1,2], [3,4,5], [6,7,8], 
		[0,3,6], [1,4,7], [2,5,8], 
		[0,4,8], [2,4,6]          
	]

	for w in wins:
		if board[w[0]].text == player and board[w[1]].text == player and board[w[2]].text == player:
			highlight_win(w)
			return true

	return false

func check_draw():
	for cell in board:
		if cell.text == "":
			return false
	return true

func highlight_win(indices):
	for i in indices:
		board[i].add_theme_color_override("font_color", Color.GREEN)

func show_winner(player):
	$WinnerPanel.visible = true
	if player == "Empate":
		$WinnerPanel/LabelWinner.text = "¡Empate!"
	else:
		$WinnerPanel/LabelWinner.text = "Ganó el jugador " + player
	for cell in board:
		cell.disabled = true


func _on_RestartButton_pressed():
	restart_game()

func restart_game():
	turn = "X"
	for cell in board:
		cell.text = ""
		cell.disabled = false
		cell.add_theme_color_override("font_color", Color.WHITE)
	$WinnerPanel.visible = false
	
func _on_btnsalir_pressed():
	const MENU_SCENE_PATH = "res://menu/principal.tscn"
	print("Cambiando a escena de menú: ", MENU_SCENE_PATH)
	var error = get_tree().change_scene_to_file(MENU_SCENE_PATH)
	if error != OK:
		print("Error al cambiar de escena. Asegúrate que la ruta sea correcta y el archivo exista.")

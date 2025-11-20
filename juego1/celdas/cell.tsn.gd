extends Node2D

# Referencias a los nodos AnimatedSprite2D dentro de esta escena
@onready var symbol_X: AnimatedSprite2D = $SymbolX
@onready var symbol_O: AnimatedSprite2D = $SymbolO

func _ready():
	# Inicialmente ocultos
	symbol_X.visible = false
	symbol_O.visible = false

# Función llamada desde el script principal (juego1.gd)
func draw_symbol(symbol: String):
	if symbol == "X":
		symbol_X.visible = true
		symbol_O.visible = false
		# *** USAMOS LA ANIMACION 'draw_symbol' DEL SymbolX ***
		# Asegúrate de que 'SymbolX' también tenga su animación correctamente nombrada.
		symbol_X.play("draw_symbol")
	elif symbol == "O":
		symbol_X.visible = false
		symbol_O.visible = true
		# *** CORRECCIÓN CRÍTICA: La animación se llama 'drawn_symbol2' ***
		# Debe coincidir exactamente con el nombre en el editor SpriteFrames
		symbol_O.play("drawn_symbol2") # <-- ¡CAMBIO HECHO AQUÍ!
	
func reset():
	# Resetea los símbolos y detiene cualquier animación en curso
	symbol_X.visible = false
	symbol_O.visible = false
	symbol_X.stop()
	symbol_O.stop()

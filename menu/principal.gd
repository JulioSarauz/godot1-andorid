extends Control

# La ruta se corrigió. Ahora va directamente a AnimatedSprite2D dentro de VBoxContainer.
@onready var animated_dragonfly: AnimatedSprite2D = $VBoxContainer/AnimatedSprite2D

func _ready():
	# Conecta la señal del botón
	$Button.pressed.connect(_on_button_pressed)
	
	# *** CORRECCIÓN: Llama a play() solo si el nodo se encontró correctamente ***
	if animated_dragonfly:
		# Inicia la reproducción de la animación.
		# Asegúrate que "dragonfly" coincida exactamente con el nombre de tu animación.
		animated_dragonfly.play("dragonfly")
	else:
		# Esto te ayudará a confirmar si la ruta sigue siendo el problema.
		print("ERROR: No se encontró el nodo AnimatedSprite2D en la ruta esperada.")

func _on_button_pressed():
	# Carga la escena principal del juego cuando se presiona el botón
	get_tree().change_scene_to_file("res://juego1/juego1.tscn")

extends Control

func _ready():
	# Conecta la señal del botón
	$VBoxContainer/Button.pressed.connect(_on_button_pressed)

func _on_button_pressed():
	get_tree().change_scene_to_file("res://juego1/juego1.tscn")

extends Button

func _ready() -> void:
	connect("pressed", Callable(self, "_on_pressed"))

func _on_pressed() -> void:
	var game = get_tree().get_root().find_child("Juego1", true, false)
	if game:
		game.restart_game()

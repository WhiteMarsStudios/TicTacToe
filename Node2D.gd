extends Node2D

var btnPressed

func _ready():
	btnPressed = false



func _on_Button_pressed():
	print("Pressed")
	if !btnPressed:
		btnPressed = true
		$Sprite.frame = get_parent().get_parent().get_parent().current_player();

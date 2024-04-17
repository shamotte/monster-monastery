extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel.visible = false
	$Panel.set_tab_title(0,"")
	$Panel.set_tab_icon(0,load("res://sprites/UI/Build_Icon.png"))
	$Panel.set_tab_title(1,"")
	$Panel.set_tab_icon(1,load("res://sprites/UI/Unit_Icon.png"))
	$Panel.set_tab_title(2,"")
	$Panel.set_tab_icon(2,load("res://sprites/UI/question-mark.png"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_check_button_toggled(toggled_on):
	$Panel.visible = toggled_on

func hide_panel(hide):
	$Panel.visible = !hide
	$CheckButton.button_pressed = !hide

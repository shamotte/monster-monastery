extends Control

enum pages {BUILDINGS,UNITS,HELP} 

var current_page = pages.BUILDINGS

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
	if $Panel/BuildingColumns.visible:
		current_page = pages.BUILDINGS
	elif $Panel/UnitColumns.visible:
		current_page = pages.UNITS
	elif $Panel/Help.visible:
		current_page = pages.HELP

func _on_check_button_toggled(toggled_on):
	show_panel(toggled_on)
	%PreviewManager.deselect()

#Hide Panel with check button
func hide_panel(hide):
	show_panel(!hide)
	$CheckButton.button_pressed = !hide

#show panel
func show_panel(show):
	if show:
		if current_page == pages.BUILDINGS:
			$Panel/BuildingColumns.visible = show
			$Panel/UnitColumns.visible = !show
			$Panel/Help.visible = !show
		elif current_page == pages.UNITS:
			$Panel/BuildingColumns.visible = !show
			$Panel/UnitColumns.visible = show
			$Panel/Help.visible = !show
		elif current_page == pages.HELP:
			$Panel/BuildingColumns.visible = !show
			$Panel/UnitColumns.visible = !show
			$Panel/Help.visible = show
	else:
		$Panel/BuildingColumns.visible = false
		$Panel/UnitColumns.visible = false
		$Panel/Help.visible = false
	$Panel.visible = show
	

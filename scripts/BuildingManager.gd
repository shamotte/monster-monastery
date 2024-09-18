extends Control

enum pages {BUILDINGS,UNITS,GROUPS,HELP,OPTIONS} 

var current_page = pages.BUILDINGS

var selecting_group : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel.visible = false
	$Panel.set_tab_title(0,"")
	$Panel.set_tab_icon(0,load("res://sprites/UI/Build_Icon.png"))
	$Panel.set_tab_title(1,"")
	$Panel.set_tab_icon(1,load("res://sprites/UI/Unit_Icon.png"))
	$Panel.set_tab_title(2,"")
	$Panel.set_tab_icon(2,load("res://sprites/UI/Group_Icon.png"))
	$Panel.set_tab_title(3,"")
	$Panel.set_tab_icon(3,load("res://sprites/UI/question-mark.png"))
	$Panel.set_tab_title(4,"")
	$Panel.set_tab_icon(4,load("res://sprites/UI/Options_Icon.png"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("menu_toggle"):
		hide_panel($Panel.visible)

func _on_check_button_toggled(toggled_on):
	print($Panel.current_tab)
	show_panel(toggled_on)
	%InfoPanel.deselect()

#Hide Panel with check button
func hide_panel(hide):
	show_panel(!hide)
	$CheckButton.button_pressed = !hide
	
	

#show panel
func show_panel(show):
	if show:
		print(current_page)
		if current_page == pages.BUILDINGS:
			$Panel/BuildingColumns.visible = show
			$Panel/UnitColumns.visible = !show
			$Panel/GroupManager.visible = !show
			$Panel/Help.visible = !show
			$Panel/Options.visible = !show
		elif current_page == pages.UNITS:
			$Panel/BuildingColumns.visible = !show
			$Panel/UnitColumns.visible = show
			$Panel/GroupManager.visible = !show
			$Panel/Help.visible = !show
			$Panel/Options.visible = !show
		elif current_page == pages.GROUPS:
			$Panel/BuildingColumns.visible = !show
			$Panel/UnitColumns.visible = !show
			$Panel/GroupManager.visible = show
			$Panel/Help.visible = !show
			$Panel/Options.visible = !show
			$Panel/GroupManager/SelectedGroupPanel.update_group_slots()
			
		elif current_page == pages.HELP:
			$Panel/BuildingColumns.visible = !show
			$Panel/UnitColumns.visible = !show
			$Panel/GroupManager.visible = !show
			$Panel/Help.visible = show
			$Panel/Options.visible = !show
		elif current_page == pages.OPTIONS:
			$Panel/BuildingColumns.visible = !show
			$Panel/UnitColumns.visible = !show
			$Panel/GroupManager.visible = !show
			$Panel/Help.visible = !show
			$Panel/Options.visible = show
	else:
		set_current_page()
		$Panel/BuildingColumns.visible = false
		$Panel/UnitColumns.visible = false
		$Panel/GroupManager.visible = false
		$Panel/Help.visible = false
		$Panel/Options.visible = false
	$Panel.visible = show
	
func set_current_page():
	if $Panel/BuildingColumns.visible:
		current_page = pages.BUILDINGS
	elif $Panel/UnitColumns.visible:
		current_page = pages.UNITS
	elif $Panel/GroupManager.visible:
		current_page = pages.GROUPS
	elif $Panel/Help.visible:
		current_page = pages.HELP
	elif $Panel/Options.visible:
		current_page = pages.OPTIONS

func set_current_pageE(page : pages):
	current_page = page

func _on_panel_tab_changed(tab):
	if tab == pages.GROUPS:
		if %SelectedGroupPanel.get_current_group() == null:
			%SelectedGroupPanel.set_first_group()
		%SelectedGroupPanel.update_group_slots()
		
func selecting_group_mode(mode : bool):
	selecting_group = mode
	
func set_spawning_group(group : PriorityTable):
	if not selecting_group:
		return
	%UnitsInfo.set_current_group(group)
	current_page = pages.GROUPS
	$Panel.current_tab = current_page
	#menu_manager.get_node("Panel").get_node("GroupManager").get_node("SelectedGroupPanel").set_current_group(selected_unit.priorities)
	#show_panel(true)
	#menu_manager.get_node("CheckButton").button_pressed = true
		

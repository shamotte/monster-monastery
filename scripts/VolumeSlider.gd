extends HSlider

@onready var _bus := AudioServer.get_bus_index("Master")

func _ready():
	AudioServer.set_bus_volume_db(_bus, linear_to_db(value))

func _on_drag_ended(value_changed):
	AudioServer.set_bus_volume_db(_bus, linear_to_db(value))

extends Button

var contact_name: String

signal contact_pressed(String)

func _ready() -> void:
	pressed.connect(_on_button_pressed)

func set_contact_name(c_name: String) -> void:
	contact_name = c_name
	text = contact_name

func _on_button_pressed() -> void:
	emit_signal("contact_pressed", contact_name)

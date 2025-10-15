extends Node

# A global controller designed to handle cookie save and manipulation

@export var stub_mode: bool
@export var stub_savepoint: String

var savepoint: String = ""
const SAVEPOINT_NAME: String = &"save_data"

func retrieve_savepoint() -> String:
	if stub_mode:
		return stub_savepoint
	else:
		return savepoint

func set_savepoint(new_savepoint: String):
	if stub_mode:
		stub_savepoint = new_savepoint
	else:
		savepoint = new_savepoint
		var document: JavaScriptObject = JavaScriptBridge.get_interface(&"document")
		if document != null:
			# Set the new savepoint cookie
			document.cookie = "%s=%s; SameSite=None; Secure" % [SAVEPOINT_NAME, new_savepoint]

func reload_page():
	if stub_mode:
		# A workaround over the hard browser reload
		get_tree().reload_current_scene()
	else:
		var window: JavaScriptObject = JavaScriptBridge.get_interface(&"window")
		if window != null:
			window.location.reload()

func open_page(url: String):
	if not stub_mode:
		var window: JavaScriptObject = JavaScriptBridge.get_interface(&"window")
		if window != null:
			window.open(url, "_blank")

func download_file(content: String, filename: String):
	if stub_mode:
		FileAccess.open(filename, FileAccess.WRITE).store_string(content)
	else:
		JavaScriptBridge.download_buffer(
			content.to_utf8_buffer(),
			filename
		)

func _ready() -> void:
	# Retrieve cookie information
	var document: JavaScriptObject = JavaScriptBridge.get_interface(&"document")
	if document != null:
		# Find the save_date cookie
		var cookies: PackedStringArray = document.cookie.split("; ")
		for cookie in cookies:
			if cookie.begins_with(SAVEPOINT_NAME):
				savepoint = cookie.get_slice("=", 1)

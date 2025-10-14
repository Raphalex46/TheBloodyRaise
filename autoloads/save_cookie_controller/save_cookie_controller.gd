extends Node

# A global controller designed to handle cookie save and manipulation

var savepoint: String = ""
const SAVEPOINT_NAME: String = &"save_data"

func retrieve_savepoint() -> String:
	return savepoint

func _ready() -> void:
	# Retrieve cookie information
	var document: JavaScriptObject = JavaScriptBridge.get_interface(&"document")
	if document != null:
		# Find the save_date cookie
		var cookies: PackedStringArray = document.cookie.split("; ")
		for cookie in cookies:
			if cookie.begins_with(SAVEPOINT_NAME):
				savepoint = cookie.get_slice("=", 1)

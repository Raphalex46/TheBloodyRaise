extends Node

var _permission_callback = JavaScriptBridge.create_callback(_on_permissions)

func _send_notification():
	var notificationJS = JavaScriptBridge.get_interface("Notification")
	notificationJS.requestPermission().then(_permission_callback)
	
	var document = JavaScriptBridge.get_interface("document")
	document.cookie = "name=Erwan; SameSite=None; Secure"
	
	JavaScriptBridge.download_buffer("Hello".to_utf8_buffer(), "hello.txt")
	
func _reload_page():
	var window = JavaScriptBridge.get_interface("window")
	window.open("http://www.erwan-auer.com", "_blank")
	#window.location = "http://www.erwan-auer.com"
	#window.location.reload()
	
func _on_permissions(args):
	var permission = args[0]
	if permission == "granted":
		print("Permission granted, sending notification.")
		JavaScriptBridge.create_object("Notification", "Hi there!")
	else:
		print("No permission granted")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		_send_notification()
	
	if Input.is_action_just_pressed("ui_cancel"):
		_reload_page()
